class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/0.4.0/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "22ee496ea5ce9bcaf8f0044771115c6f1bcf25f4403413f3e8572d1a0ff1ff11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/0.4.0/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "1115c9a1ba5ac944fab544c99e8aa4577cd890380b1803ed6dd82cdc937b6147"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/0.4.0/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "378ac2c5702d7bdf7e728205f5963b7487e473f8092aa30ec401e5c604911dc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/0.4.0/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c0c2d03200010235a559175f324db53795c4d3e631a5aa6f30e88edcc50b4a9"
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
    bin.install "icu" if OS.mac? && Hardware::CPU.arm?
    bin.install "icu" if OS.mac? && Hardware::CPU.intel?
    bin.install "icu" if OS.linux? && Hardware::CPU.arm?
    bin.install "icu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
