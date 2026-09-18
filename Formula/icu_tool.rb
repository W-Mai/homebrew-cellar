class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://i.to01.icu/"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.11.1/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "397106d314fee020821bc25a3cf594007ee769b5776cf13d9761c865fe921202"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.11.1/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "93fed3ade0f7248f84cc79179341ba7cfa13a57ccad221cf4b93dfec095f0f18"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.11.1/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7909bbdd03f24d0d5326a1c685d119d624a97cef667d311c4c4c28519ac0587b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.11.1/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "304b462259ed303e262c46f53fd6ea350ec848e576af1644c7ae5eb14de919b6"
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
