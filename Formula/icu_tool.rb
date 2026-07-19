class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://w-mai.github.io/icu"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.5.0/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "b658b406f3b87e4dbfb810455dbee612463c5ab25bf75efea9d9174c35f99921"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.5.0/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "c252256521db32e1f4734610ddb559ba95f8777ba0fb3b90bb022e547ec14c3f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.5.0/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "12488617b8e6725ba3918ec469881bf6c9854a34b5c7d9f32298bac44e53f813"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.5.0/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d8641bec812f553f469e5bd7302018a07a9676572cf9f34fee89d0d44dde774"
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
