class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.12.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bc96b703cca2ea59d6ca6a637cf698305e77f03a3b8fc2594546927e2a183424"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.12.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "312a66ebac4d4beba3ddb4b7c9da6461aa3074b334270e7ab1fd161d0ecf2e98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.12.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d60f52beebcf691a7adde1b2099480722a8a46e0cf184d3a124f99c022cddb5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.12.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3106ba56ddac53cf22d903108f07bca1ca5a76820143fea0524b1a56c134555c"
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
