class Vegravis < Formula
  desc "Vegravis is a vector graphics visualizer.It can visualize vector graphics on a canvas, and can also visualize vector graphics in other formats through conversion."
  homepage "https://w-mai.github.io/vegravis"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.3.2/vegravis-aarch64-apple-darwin.tar.xz"
      sha256 "59ae0a689b2902ae861501faffeb960e788e7fc8f191463a59f29d11a9de14c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/vegravis/releases/download/v0.3.2/vegravis-x86_64-apple-darwin.tar.xz"
      sha256 "4ea811a1e1f600cd27d73202301b5daba6192ea16d64e3fc612f423a0ca238af"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/W-Mai/vegravis/releases/download/v0.3.2/vegravis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "62b004034ed348541a125b409a1561199a08be01e61bea735df85ed3483fdec6"
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
