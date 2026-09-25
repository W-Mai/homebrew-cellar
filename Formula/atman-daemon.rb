class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.2/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "18f7cde301159ce05d96444472cf034e2ee8afa858803bb390170d8e595f515f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.2/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "2b356238fedefb8a7578dfd912885a334ce60aeccb882aebdc1a79ddb768c734"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.2/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aaa98fe310923cd7480eb13ba412f40907d6c4ad27faa016dca2495f4f407f54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.2/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "61f4bddb6c70e3c02a12a8688854945736a6024ce32321cf1663d4b49017cce0"
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
