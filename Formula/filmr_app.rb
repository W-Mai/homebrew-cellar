class FilmrApp < Formula
  desc "CLI and GUI application for filmr, a high-fidelity film simulation engine."
  homepage "https://benign.host/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.5.0/filmr_app-aarch64-apple-darwin.tar.xz"
      sha256 "df25b47f44e67ffd52b3bf5299c1c27f81779a6e2ff0689cd5439045bd6fe257"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.5.0/filmr_app-x86_64-apple-darwin.tar.xz"
      sha256 "1eecf06166b4f5db65696343dd9e7b8a7d9ea79d3116245be53ee5af35b124f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.5.0/filmr_app-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6383c3c0fbc205b06fde6ce668ee519e29eb491e1d05a460cc5ec544d5123f20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.5.0/filmr_app-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d3174b8e8ff74437140a68d390e134f601a4d1cb9f08ba0de2d9ae03198394f"
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
    bin.install "filmr", "filmr-cli", "filmr-ui" if OS.mac? && Hardware::CPU.arm?
    bin.install "filmr", "filmr-cli", "filmr-ui" if OS.mac? && Hardware::CPU.intel?
    bin.install "filmr", "filmr-cli", "filmr-ui" if OS.linux? && Hardware::CPU.arm?
    bin.install "filmr", "filmr-cli", "filmr-ui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
