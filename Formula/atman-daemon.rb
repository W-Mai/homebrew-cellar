class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.20.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "c2a108d112bbac951584518e2d47180b444055780bca9b470f68e9d150aebc21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.20.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "de0e6688fad7c80fc78aac0829cdde3f63ef516c57b92abed674663d41ac8e98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.20.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e0129e8b5254a93a144695315ce5667a1761aa32382559f2c1c9d30b69859ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.20.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfbd72fee4031936f7391679621966668c7cb7354307dba61d7fa27a80246637"
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
