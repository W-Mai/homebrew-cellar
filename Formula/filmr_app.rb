class FilmrApp < Formula
  desc "CLI and GUI application for filmr, a high-fidelity film simulation engine."
  homepage "https://benign.host/"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.9.1/filmr_app-aarch64-apple-darwin.tar.xz"
      sha256 "49e33c7b14b7b958d018e189b067ae710ac477f67afbbbd034a0cde401f04c5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.9.1/filmr_app-x86_64-apple-darwin.tar.xz"
      sha256 "f03bd5e0f0bd22fec8abcb5f8f1549fa20b88dcb4d54a360f4be3b12fed8b468"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.9.1/filmr_app-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "71774843b0cb28b3105d7d8478e8aac0d5f4f0727f89897c85f868f934f03b11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.9.1/filmr_app-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa190b86defe7af06d54d25bb508064bf8fa06c7a979e894fd0feaa1d0df9630"
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
