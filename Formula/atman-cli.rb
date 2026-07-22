class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f33ecf0a2f6541dd2e97eadb2ea873d3a4faace9940449967e782ae9535c5323"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "59f64aa9342951c5bb63779cefaf1b9f3e34f9f25a335dd41d619b97c46deca1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e74d7b9e40d49137823d11175eae7a9944f9b622139b11eed9395a005223dd06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "adc053f0b625af8d04c31c813a3c972788a96388469fb7e16dfc6a9315a5b809"
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
