class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.6.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "3f202c04826d72f89dcdc84bdf76f53d52f2e199a2be1ca4bbd10a2074f1a6ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.6.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "a36ae0fe15bca918cde5467def954dd39011e038fe0616771663e5864f95a68b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.6.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "718f77192ce87c8bbee854d092ff0ae28c33fd8534c0cfcc07629e36fc674547"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.6.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "20275614e0a0c3e44f008ccbc62b7d322417e8aea9d65ccb5a3aa37e8e2e74f9"
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
