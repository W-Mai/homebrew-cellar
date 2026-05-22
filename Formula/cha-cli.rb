class ChaCli < Formula
  desc "Cha — pluggable code smell detection CLI (察)"
  homepage "https://github.com/W-Mai/Cha"
  version "1.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.19.0/cha-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c1aa46d8571ac5e92a9456f83ad919194014e149005c0813fa2b1ad0a7a3de7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.19.0/cha-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1a04012ff77fa5e87d885361e3a30ef4069ee423fb58755073b81e7b9073f11e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.19.0/cha-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b6a50699bf3043008efb10066b42ed0003f5dedba34b350fee11f288ecd783a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.19.0/cha-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "739cc9ffb5d81b7a7bf2e284a80836077639f05a3670e385f688410cbc3e023f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "cha" if OS.mac? && Hardware::CPU.arm?
    bin.install "cha" if OS.mac? && Hardware::CPU.intel?
    bin.install "cha" if OS.linux? && Hardware::CPU.arm?
    bin.install "cha" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
