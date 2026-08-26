class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.1/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "6ea28203683ea5fcb7870447b28c219a68e1b2d428b3bf76de859168bcc9be73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.1/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "6d90a86c68f337c71e6ce4d4bf5a0f5b144469223b95d6bb16e6d6817d46a7de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.1/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e47b9861bc67db3286463a9878e989c21644fc359e81e5e1448da43141a3a5db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.1/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ed3c52e17a49c1249af2189970b1eb46ccfae494c6ee07a2a21f712e3911617"
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
