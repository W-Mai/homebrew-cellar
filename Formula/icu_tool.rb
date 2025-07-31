class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.16/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "80afb92d38257e7a99103ff8692c291fc88b0ebad6d232a0c9e558c5ff8d8265"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.16/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "fbd7239070b8bcf25f54b7d6a0246688cdd3a1a6bd569b4d937c1d4e5932ebc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.16/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7278a211f13e7c71afc321b8cad91d7098d0e137752db38b78cedfc2f32c0b89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.16/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1836c7380559096dbe664c40848e2d57c76072b3e64193ca1827e0194499c163"
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
