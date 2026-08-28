class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.10.0/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "bc6a5393b2bccaa50403fa6cee7b0e986ccfa628b4380f5abb6289aa9c969760"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.10.0/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "b703f0727709253843cd24fb8b7d7e3663d2ba75b96aa2d1b9944a702b343add"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.10.0/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eec8d3e6ff9fc613c077175d0ef95b29393ef39195985e7118f75b2570f39406"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.10.0/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e2dfcab93a2f4df5039e8c2b3e9dd2e254846bcbbb2d6f9956f7484698825e4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "icu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "icu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "icu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "icu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
