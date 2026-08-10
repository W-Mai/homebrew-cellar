class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.7.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "aae58bb508cc361e4c0e1ec02cbc7686efe2a2cdf51fdd803de0b1e2b2f36dcf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.7.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2b3c0c12467bba2bdf2d1f358dd692fb0e8ca6ca9bd21c1a19626071e06ede32"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.7.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d264e729f705f0d9395bc1a12a2ec9688be46aabe4a39fa2a4c449f3c3ae56b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.7.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77b087ccbdd7aa4944cd43dd4e21e3a3e79befda89a588db933b5f37c96699b4"
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
    bin.install "atman" if OS.mac? && Hardware::CPU.arm?
    bin.install "atman" if OS.mac? && Hardware::CPU.intel?
    bin.install "atman" if OS.linux? && Hardware::CPU.arm?
    bin.install "atman" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
