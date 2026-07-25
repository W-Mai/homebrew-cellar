class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.2.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "34901bf4da5b8f2fc618edb514c5a3fc9a4b9005775cdc11910fcfc6a28addc4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.2.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "bdb0948598876ee2e1436bcef186e877f525aa007b598790c9715d42602a4e7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.2.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fae94189727b4245b6599dacdb6e8b4b37c895df16bcf466c991ebe1acb36c1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.2.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b2af34b5ef239a588abb9c7d6d52c2f83dfceceb54b5a307cd20ebfe747a736"
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
