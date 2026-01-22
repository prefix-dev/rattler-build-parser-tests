#!/bin/bash

cargo auditable build --release --package macos-certificate-truster \
    --target "$CARGO_BUILD_TARGET"
lipo -create -output target/release/macos-certificate-truster \
    "target/$CARGO_BUILD_TARGET/release/macos-certificate-truster"

(
  cd mitmproxy-macos/redirector && \
  mkdir build && mkdir dist && \
  # 1. Create an unsigned .xcarchive
  # Unset conda-forge compiler env vars so xcodebuild uses system Xcode toolchain.
  # The conda-forge ld64 956.6+ has an LTO library incompatibility with xcodebuild:
  # "ld: -lto_library library filename must be 'libLTO.dylib'"
  unset CC CXX OBJC OBJCXX LD LDFLAGS CFLAGS CXXFLAGS CPPFLAGS
  # The xcode scheme has a post-action that tries to copy to /Applications,
  # which fails on CI. We ignore the exit code and verify the archive exists.
  xcodebuild \
    -scheme macos-redirector \
    -archivePath build/macos-redirector.xcarchive \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGN_IDENTITY="" \
    archive || true
  # Verify the archive was created successfully
  test -d build/macos-redirector.xcarchive/Products/Applications/"Mitmproxy Redirector.app" && \
  # 2. Copy the .app out of the .xcarchive (the .xcarchive is just a folder)
  cp -R \
    build/macos-redirector.xcarchive/Products/Applications/"Mitmproxy Redirector.app" \
    "build/Mitmproxy Redirector.app" && \
  # 3. Create the .app.tar bundle in dist
  tar --create \
    --file "dist/Mitmproxy Redirector.app.tar" \
    --cd build \
    "Mitmproxy Redirector.app"
  rm -rf build
)

$PYTHON -m pip install ./mitmproxy-macos
cargo-bundle-licenses --format yaml --output ./THIRDPARTY.yml
