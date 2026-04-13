class FilmrApp < Formula
  desc "CLI and GUI application for filmr, a high-fidelity film simulation engine."
  homepage "https://benign.host/"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.7.2/filmr_app-aarch64-apple-darwin.tar.xz"
      sha256 "1d1ebf3f270659f45adf07f48bb2de111a5f5d19698892775f33453cd316d1d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.7.2/filmr_app-x86_64-apple-darwin.tar.xz"
      sha256 "697059f8a6fc8187179b5c1972f864e4a4880730d761c295472101c5be3e4ec1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.7.2/filmr_app-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "202ff1bd96b70ad04cf942b12e337bcded987e1bea3fa4b2df5c4cea881bb152"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.7.2/filmr_app-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddaff5b700cda5fa20f80adcfea1116e2cd5baf2bf3f089cebc5194b1300e22d"
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
