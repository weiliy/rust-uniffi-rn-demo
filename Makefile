IOS_TARGETS = aarch64-apple-ios x86_64-apple-ios
MACOS_TARGETS = aarch64-apple-darwin x86_64-apple-darwin

RELDIR = release-smaller
STATIC_LIB_NAME = libdemoffi.a

# Colors
RESET = \033[0m
BOLD = \033[1m
YELLOW = \033[33m

BEG = "$(YELLOW)$(BOLD)"
END = "$(RESET)"

define log
	@echo $(BEG)$(shell date "+%Y-%m-%d %H:%M:%S") $(1) $(END)
endef

.PHONY: build
build: build-ios build-macos generate build-xcframework

.PHONY: clean
clean:
	cargo clean

generate: target/include
	$(call log, "Generate Swift bindings")
	cargo run --bin uniffi-bindgen generate src/demo.udl --language swift --out-dir ios/Demo/Sources/Demo --no-format
	mv ios/Demo/Sources/Demo/demoFFI.h target/include/demoFFI.h
	mv ios/Demo/Sources/Demo/demoFFI.modulemap target/include/module.modulemap

target/include:
	mkdir -p target/include

target/lipo-ios/release-smaller:
	mkdir -p target/lipo-ios/release-smaller

target/lipo-macos/release-smaller:
	mkdir -p target/lipo-macos/release-smaller

build-ios: $(patsubst %,build-ios-%,$(IOS_TARGETS)) target/lipo-ios/release-smaller
	$(call log, "Build iOS Build Universal Binary")
	lipo $(patsubst %,target/%/release-smaller/libdemoffi.a,$(IOS_TARGETS)) \
		-create -output target/lipo-ios/release-smaller/libdemoffi.a
	@file target/lipo-ios/release-smaller/libdemoffi.a | grep "universal binary"

build-macos: $(patsubst %,build-macos-%,$(MACOS_TARGETS)) target/lipo-macos/release-smaller
	$(call log, "Build macOS Build Universal Binary")
	lipo $(patsubst %,target/%/release-smaller/libdemoffi.a,$(MACOS_TARGETS)) \
		-create -output target/lipo-macos/release-smaller/libdemoffi.a
	@file target/lipo-macos/release-smaller/libdemoffi.a | grep "universal binary"

build-ios-%:
	$(call log, "Build iOS for $*")
	cargo build  --profile $(RELDIR) --target $*

build-macos-%:
	$(call log, "Build macOS for $*")
	cargo build  --profile $(RELDIR) --target $*


build-xcframework:
	$(call log, "Build iOS XCFramework")
	rm -rf ios/Demo/demoffi.xcframework
	xcodebuild -create-xcframework \
		-library "target/lipo-macos/$(RELDIR)/$(STATIC_LIB_NAME)" \
		-headers "target/include" \
		-library "target/aarch64-apple-ios/${RELDIR}/$(STATIC_LIB_NAME)" \
		-headers "target/include" \
		-output "ios/Demo/demoffi.xcframework"
