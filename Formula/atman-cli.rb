class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.16.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "76412d565fd1471437cb5333f93d672b8fec282647a4a1458951fde7b84a448b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.16.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7bb2b2cc975d46d1ad7ccf852a95772e3697f04cf7406bb57bb5f7d51b8cc589"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.16.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ab35e87f88b903a8f685bdf7aab030db5311546cc1a239d7cbe4fdca2d623cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.16.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "365b8cdb396f7e50e0afb9704d7489e8602279d06b6d15bfabe7065d568a25fe"
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
