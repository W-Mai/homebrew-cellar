class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.4.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "c6b40d62561d1d2b507bfffa3ae60cbfee80d4e0bc851a80f5862aadbe852c6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.4.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "630ce5d7a2c31d9c0dffb5f2cb5bbf7667b978c1cf0b5520b9c39502b901541f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.4.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "560976590f63972392f38ef329f6c8d99d47ad67c1e89bdbd2d55dbf5379d349"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.4.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73ef4c46d12e2b2f0bf7b4b42ed83c6dc09a7b3534af83654c82fc4991d4696d"
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
    bin.install "atman-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "atman-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "atman-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "atman-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
