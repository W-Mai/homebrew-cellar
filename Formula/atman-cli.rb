class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.17.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.17.2/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "378311f225c17ce7eb7e50163383d3ca880d5aba73940a3b8ba4a4e666f13262"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.17.2/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "16983f54b3e62247a70e5ac5c589cfb2d54ea3cdbec85a24f095b31d5d5cfe18"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.17.2/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "69b4bf3204427bdd5d4b5bc3e092dc81157f69578ae2ba76dd3bbe6476f6c35c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.17.2/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad623b91c3755887bfb8e22f5202a273e7e599394d0dd09fa5638423d17e7f28"
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
