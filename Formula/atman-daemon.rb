class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.3.0/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "6aa1e1a3369dbfd9a4a5e1c67fd366dff6f7127a80098d2fd200b780d5c3854c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.3.0/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "95b05dd10f8cebe9c87abffd94642a400a647f4ebdf46a6bffeb8c1718d96e97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.3.0/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf3a0f23bd81fdbc476e967269ef0dfcc2068612849cdea5b6aee60d50008e8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.3.0/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2db09c6981545a92ce96cc46946238fb850aba6895cda7a9244c142c562f9a2"
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
