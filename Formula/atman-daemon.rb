class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.8.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "70c85dd0ec662702be2a419ebcbc46f358d7b8fc5550841cf11bded6f7495c57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.8.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "860ec2be23540224da0bbb254533e63953a3c3b8bf160072f3426b3040daa52b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.8.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5acabfe43eba09a0915888a69d1ed71f2f21e353926f2913bec706db5a9ec6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.8.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fc25478e2949cd096721cdc5c42afebe77adc850a3fc76f49873a5dd45f152c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "atman-daemon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atman-daemon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "atman-daemon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atman-daemon"
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
