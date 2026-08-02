class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.5.0/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e62c29b9d370618a048502512c6106ee5de8b770d6f69776a1140e23d1f1a198"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.5.0/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fd168a70abd2117ddc127e181f1587648e3c56f488bd59929f6208623273c220"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.5.0/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "237e1760a34c658968a4de8fd5db63b84d9e942e71413a214a53805c3d18444b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.5.0/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "559bbf1e911a64d2cd73c06562f71a31de5f5fc5a09ff62433ec73514491ec68"
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
