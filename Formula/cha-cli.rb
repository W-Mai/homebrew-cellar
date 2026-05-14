class ChaCli < Formula
  desc "Cha — pluggable code smell detection CLI (察)"
  homepage "https://github.com/W-Mai/Cha"
  version "1.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.14.0/cha-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5bac4e050c8ade566bdf5aadda52cd26a5077ce1058d2fa7fd4c5670f5657a3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.14.0/cha-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4b27253920d27c43ae758c32de5b5a37a9981a2e858b7efc255d801159e82216"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.14.0/cha-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b036137a0a22d5bd1170f7ea09cc9cc68ee21e7e56b21f793affdf987b5e666"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.14.0/cha-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f065172fa3bad9a893e7cf5a9c58372e71a39a573bdb2ce8108df53f86f9d08"
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
