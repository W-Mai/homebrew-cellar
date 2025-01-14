class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.15/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "60fc66fdcfccbedc34d7fc7ab5d9b180cc903a3761b39742bea4f30940e727db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.15/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "223bf1a5e32e6d2c203206937d0e6155b44a934e2568208c6f8e8ea4c556ac01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.15/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "44b3a77d0a9bbaebde849d54c6e6c7fafd00e07044cd3611517e17b9df4de09b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.15/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aac7d4501b425456a4b45e5f195364113cd498e7ade9d90e1c888821e45c1832"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "icu" if OS.mac? && Hardware::CPU.arm?
    bin.install "icu" if OS.mac? && Hardware::CPU.intel?
    bin.install "icu" if OS.linux? && Hardware::CPU.arm?
    bin.install "icu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
