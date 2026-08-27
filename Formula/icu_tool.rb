class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.9.0/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "263b36761668a2a4215150444c47124a3f1f67438ed12b747e41795ad741cb79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.9.0/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "9d7321f3765c9b93a71f461477721f8a6f9c607b8a2d4d7d3fd4381e25da0894"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.9.0/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e01fd79e0a228d69b1d931f5ec7a5460d446c14ddf7b83b76e3cb9a9916d3557"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.9.0/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d70de1a9e248d1656f5f5717df6ca6424dbfa16dfbfae74f98dc7a146b3f25d3"
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
