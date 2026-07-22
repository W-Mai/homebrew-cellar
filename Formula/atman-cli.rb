class AtmanCli < Formula
  desc "atman command-line interface"
  homepage "https://atman.run"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7fcebf188963557a64befaf0c5feec430d13731c6185b89979c696671c3601b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d1763196519444b1feeae9b22ee2d2757af2313609ecb32930f9b3dd74bcac32"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27a9b02dd0ab8ccb449d3cdd42720ee21110200d667ec7076fdde41451d4272c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e96e1927d0c884e15976f9917fadba681420f81c95e3dae96fe6fc5b47f612d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
    bin.install "atman" if OS.mac? && Hardware::CPU.arm?
    bin.install "atman" if OS.mac? && Hardware::CPU.intel?
    bin.install "atman" if OS.linux? && Hardware::CPU.arm?
    bin.install "atman" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
