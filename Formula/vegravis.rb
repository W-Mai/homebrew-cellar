class Vegravis < Formula
  desc "Vegravis is a vector graphics visualizer.It can visualize vector graphics on a canvas, and can also visualize vector graphics in other formats through conversion."
  homepage "https://w-mai.github.io/vegravis"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.4.2/vegravis-aarch64-apple-darwin.tar.xz"
      sha256 "161df3d857c84eccbfb9f48e93c537f53ac92497683b813146a4c0294c7521e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.4.2/vegravis-x86_64-apple-darwin.tar.xz"
      sha256 "6fb3befc3feb00c8da4b00822d4e9e52b1db9ac9f7fe55d43f0ac356e3d7c81b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/W-Mai/vegravis/releases/download/v0.4.2/vegravis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d1bb96a1d4f253eccad7e3b8e07687ec8550911ba9991f05095a5269c51d62e5"
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
