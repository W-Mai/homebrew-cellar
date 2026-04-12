class ChaCli < Formula
  desc "Cha — pluggable code smell detection CLI (察)"
  homepage "https://github.com/W-Mai/Cha"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v0.5.1/cha-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bf37bd39ae0e1d45067797d659c08a61b1d53d0b10dcedc41b5bc135822bb129"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v0.5.1/cha-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2641a99cd8cca5386ed64c9a85111d246ec4cb3706fc57602e832f84b715bd29"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v0.5.1/cha-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d322ce63244b5791eef9d192099274a3721da1aa4697867a1e0f014eed4d987b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v0.5.1/cha-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "415e772821c35815dfa7101f28dbdd4f63997338eed11c1a8246853201da8498"
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
