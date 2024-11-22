class Vegravis < Formula
  desc "Vegravis is a vector graphics visualizer.It can visualize vector graphics on a canvas, and can also visualize vector graphics in other formats through conversion."
  homepage "https://w-mai.github.io/vegravis"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.4.1/vegravis-aarch64-apple-darwin.tar.xz"
      sha256 "45212721dc31240e3b1c51f2fe7d2cc653823d842780f3efd5b33381c2c5d5cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.4.1/vegravis-x86_64-apple-darwin.tar.xz"
      sha256 "4acf3332038e2aa90807709229ffcb94e44851247c37e54fee94211f08aeb720"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/W-Mai/vegravis/releases/download/v0.4.1/vegravis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1a789f798c479d48dac8ba5a3b7581a42b590b95eefad33aa251d7aa2ab35bd5"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "vegravis" if OS.mac? && Hardware::CPU.arm?
    bin.install "vegravis" if OS.mac? && Hardware::CPU.intel?
    bin.install "vegravis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
