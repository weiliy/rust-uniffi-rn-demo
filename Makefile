.PHONY: build
build:
	cargo build

.PHONY: clean
clean:
	cargo clean


generate:
	cargo build --release
	cargo run --bin uniffi-bindgen generate src/demo.udl --language swift --out-dir target/demo-swift
