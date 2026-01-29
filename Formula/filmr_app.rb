class FilmrApp < Formula
  desc "CLI and GUI application for filmr, a high-fidelity film simulation engine."
  homepage "https://benign.host/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.4.0/filmr_app-aarch64-apple-darwin.tar.xz"
      sha256 "fafc5d7352042e5510ef122bbb65040fa55d1a141d5c7c9218a383599391428e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.4.0/filmr_app-x86_64-apple-darwin.tar.xz"
      sha256 "88bc319ed41f1e1085aa54db57c892f4630c67b5b6f9c1e1a8d7ca1a54b2eed0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/filmr/releases/download/v0.4.0/filmr_app-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46f6dc1351655bf4f4c10726a3d51ccbd7d33b037f01d3393379cef5388e4e59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/filmr/releases/download/v0.4.0/filmr_app-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4314eb5939b8c7a4d2893cc6a47e0bd45ac62f7784190822f91e3a21a3ab4895"
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
