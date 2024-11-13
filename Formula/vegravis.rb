class Vegravis < Formula
  desc "Vegravis is a vector graphics visualizer.It can visualize vector graphics on a canvas, and can also visualize vector graphics in other formats through conversion."
  homepage "https://github.com/W-Mai/vegravis"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.2.1/vegravis-aarch64-apple-darwin.tar.xz"
      sha256 "c626eaa09213a37af0338bcf1c65cf39136bdaca67da8227c7747c00d2c25ded"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.2.1/vegravis-x86_64-apple-darwin.tar.xz"
      sha256 "f3e7027faf30583914aaee74829733374c5776abeb80f795ac91543e3fc3fad0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/W-Mai/vegravis/releases/download/v0.2.1/vegravis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "003b3207d149987687eab3c6e8af03ce89fca71ebf99f40bd07b9a3792702a1b"
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
