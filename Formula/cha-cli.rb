class ChaCli < Formula
  desc "Cha — pluggable code smell detection CLI (察)"
  homepage "https://github.com/W-Mai/Cha"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.7.0/cha-cli-aarch64-apple-darwin.tar.xz"
      sha256 "dfc206b629abb5ef859b7e1dbdba98bfad72fc90dd966ae5061a5f0b1c360695"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.7.0/cha-cli-x86_64-apple-darwin.tar.xz"
      sha256 "27a8819547365b3bd49bb751113fd074c5b72525af90bf4d169d07276a4ed020"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.7.0/cha-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "324be30001e0ce61f5a41d6913b0c99f9e1abfae7ae00c01a3c2313fdc72f095"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.7.0/cha-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a88cca57424a9add1b201483001426865cd8faeaac00a94c1e7611d014d25267"
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
