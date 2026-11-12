class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.21.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.21.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "bffa104bf0715926ae8fbcdac608c88011cfc99c7804a7239fab0494ef1888f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.21.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "0bd089a5ec6564f822a4b5bbad656f8133c3d089f415b3fd726c6f2fd92e44b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.21.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec8b447a76c64ca844d0b3946129a30239aca749ea5cacc0bb5c68cda01dadf3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.21.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad5f1b57b22616c7cfec5ff8bc0e283bd37209d18b68250099efefd3682959b7"
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
