class ChaCli < Formula
  desc "Cha — pluggable code smell detection CLI (察)"
  homepage "https://github.com/W-Mai/Cha"
  version "1.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.10.0/cha-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9ad1806967aa2c926f3fff963587a9b58b6c26972c6e0d725d55653b0177bad3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.10.0/cha-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4b23a68394cc2ed2474bef280a53464a5814710ec6c473ff71fabbe01cdd4b64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/Cha/releases/download/v1.10.0/cha-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95bf49fd534aef3b83b0c1c192d8d519c62593686851565d9158285b12926bed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/Cha/releases/download/v1.10.0/cha-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecdc9a7da5df4488936a3c4286b45312f77d7200e178dbc459f6e0de00a7f6cc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "cha" if OS.mac? && Hardware::CPU.arm?
    bin.install "cha" if OS.mac? && Hardware::CPU.intel?
    bin.install "cha" if OS.linux? && Hardware::CPU.arm?
    bin.install "cha" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
