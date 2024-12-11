class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.14/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "f4b68e356e08d956cdea299973ef77122b42e8998ba283b2b65e13fadf0b8f6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.14/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "ecce314c8529a0a00bd038ae6090ee9436142b16dd3e707fd1ed0e4b5b176973"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.14/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "747b156ac31a5772ca04a063501e0e7ec001aea33b5f94e684b9173b4b80ad78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.14/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2c2f25d92ee06a673b2c2d98f462c15de2890664cd339f0eae09edb3c89a177"
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
