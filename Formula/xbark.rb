class Xbark < Formula
  desc "Desktop sticker popup daemon — say :sticker[laugh]: anywhere, see it fly into your screen"
  homepage "https://github.com/W-Mai/xBark"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/xBark/releases/download/v0.2.0/xbark-aarch64-apple-darwin.tar.xz"
      sha256 "ed88b9c162856726645f170db1e76ce1d1ac0f38b931e9a315a2df3d7c38cbdb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/xBark/releases/download/v0.2.0/xbark-x86_64-apple-darwin.tar.xz"
      sha256 "153c7ac358e19ae80e9f3303c8d51b47f864656585af26d9f01a4cec64a64be6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "xbark" if OS.mac? && Hardware::CPU.arm?
    bin.install "xbark" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
