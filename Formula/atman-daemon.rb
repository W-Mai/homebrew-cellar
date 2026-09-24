class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "48bff9770dedd3bc5b04cd26ce3e4df537a0d7dda782994a2015f58b1398dfe9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "47ea0a337e3a49ff1370efcfa1d9507c9f5265f9e382c13d0b8c7598815e2d6d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d794e96d8fedc0ad8c6e0ba2cf1a0a8a5ac795f6383b8e238945134a4edd5802"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5e0cc4c86357e65b2c3403fdeae3a8024d3a97fbe66d83ca3460f450d408fcd9"
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
