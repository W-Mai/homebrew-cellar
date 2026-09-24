class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c4ed9020922a952632d3969c286e7189791754cb7b479b2e6e171f5dcf4c68cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4cdf2c32734a2645c1643938822497aa84f389cb9fc469b0466e4bb41b645ce3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ff0f79273562cceebfb98c7f1f759d6415aaca2d559786db9c98b584aa504cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.13.1/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81808c6f45b793f3dda9dd96f8b57faed0d27db45a35a57bb0cc0e7668c8a8bf"
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
      bin.install "atman"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atman"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "atman"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atman"
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
