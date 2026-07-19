class AtmanCli < Formula
  desc "atman command-line interface"
  homepage "https://atman.run"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.0.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "daf9e142a33fb67a66bd8f0385b3f3bc03c4da41d6afefecf372f098bfcc5dac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.0.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b4ea95c99c263832af7be774e16b7604676b8f37d7b9ac5f6ed4d058f149611b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.0.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5539d89f4354f8bcdfc5e872d34e1b1b02b8be3b1ef439bc02f325ffcfc91106"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.0.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "acc57c77d03084f2e9c1fec8d7a7101073c3055c440f830365bbc7754d220a0d"
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
