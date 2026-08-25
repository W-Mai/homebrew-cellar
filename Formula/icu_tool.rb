class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.0/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "1428713d51f24146be87d40bb73bbf538ad96982d45c5980d054d6cfd58ebc61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.0/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "b1f7508ee7d45778098efcb4980d9094223d1064d17246946185442431ff582f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.0/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "babd31a54c8b07a983fceefb6f110e1c02c11234a905e5140b91d984c4e51877"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.8.0/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58ca74d1ccb8a7c37cee55f1016479c5eb219bd231bd2b09222fa72033e028b3"
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
