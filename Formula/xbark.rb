class Xbark < Formula
  desc "Desktop sticker popup daemon — say :sticker[laugh]: anywhere, see it fly into your screen"
  homepage "https://github.com/W-Mai/xBark"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/xBark/releases/download/v0.1.3/xbark-aarch64-apple-darwin.tar.xz"
      sha256 "104a4c634065fa7ca517718b31cff1177cfe93bbfcd6e9f8e502ea3a5577af3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/xBark/releases/download/v0.1.3/xbark-x86_64-apple-darwin.tar.xz"
      sha256 "d85aaf6fb6f3b658dcbf090eeab0cefbec00415adfd173dc359e9bd18047aadd"
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
