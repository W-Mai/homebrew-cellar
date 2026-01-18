class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.22/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "6dce81f457ad0578cc13ec0f7dd3ed2a31630aaea0471d0b4823cfe7b8422a5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.22/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "4f92d556d44392654b46e72a8465a0a86a23ae0409853819f275436c920e384c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.22/icu_tool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "655bd9d168de1d26f0fe566d6f068441ed8d2ef54247a91f37a1092ac31ed908"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/icu/releases/download/v0.1.22/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9fc9d0aaa46a4c1684eb98f59a85e730dab3f2bf85bda8707852c7f2b2c545e9"
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
