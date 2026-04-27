class FilmrApp < Formula
  desc "CLI and GUI application for filmr, a high-fidelity film simulation engine."
  homepage "https://benign.host/"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.10.0/filmr_app-aarch64-apple-darwin.tar.xz"
      sha256 "13467217ae7d0618a6fa934644dbef166391f7dfa4568f34cfbf0b56ef0ee9e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.10.0/filmr_app-x86_64-apple-darwin.tar.xz"
      sha256 "27a0a460888f6e029baddfdadda586b62cce3f8b2e1123237c95f0d5f25d6aaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.10.0/filmr_app-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a7763f0f3eec99736bcdd78487eaa6bdee4bb39e0ae713f198fa9148fb855a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.10.0/filmr_app-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9eb374775a66ec28c4f8c17c62e5702665298a31d473b47b0783e2def5a25cc4"
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
