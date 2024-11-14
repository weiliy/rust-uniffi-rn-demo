.PHONY: build
build:
	cargo build

.PHONY: clean
clean:
	cargo clean

prepare:
	@echo "Checking if cargo is installed..."
	# uniffi-bindgen generate will use swiftformat to format the generated code
	command -v swiftformat >/dev/null 2>&1 || brew install swiftformat

generate: prepare
	cargo build --release
	cargo run --bin uniffi-bindgen generate src/demo.udl --language swift --out-dir target/demo-swift
