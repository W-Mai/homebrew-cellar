class GitRndName < Formula
  desc "Generate a random git branch name based on remote name you given."
  homepage "https://github.com/W-Mai/git_rnd_name"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/git_rnd_name/releases/download/v0.2.0/git_rnd_name-aarch64-apple-darwin.tar.xz"
      sha256 "c9b8e1f7351b32a3480f291e204c67cb040d08169361aad4997bc44fa7a99971"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/git_rnd_name/releases/download/v0.2.0/git_rnd_name-x86_64-apple-darwin.tar.xz"
      sha256 "810a096175c8fe04faf75c7594160237dc805569df3ba32eca40091278b9cfd6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/git_rnd_name/releases/download/v0.2.0/git_rnd_name-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f89811d8b359152192df21a5d980f8d3cebd6dac96b7688c189e7eca068ac46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/git_rnd_name/releases/download/v0.2.0/git_rnd_name-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5fb8a6884bb611b3369ea0a19a1d994c67b4b6127a6f0fdfdb971d93ef70ed0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "grn" if OS.mac? && Hardware::CPU.arm?
    bin.install "grn" if OS.mac? && Hardware::CPU.intel?
    bin.install "grn" if OS.linux? && Hardware::CPU.arm?
    bin.install "grn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
