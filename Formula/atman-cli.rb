class AtmanCli < Formula
  desc "atman command-line interface — AI coding agent runtime with a Turing-complete .at flow DSL"
  homepage "https://atman.run"
  version "1.19.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.19.1/atman-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ab912b97e2fb6de12d67663093243f7ad11287a8ca50e0fd9db586667c40b912"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.19.1/atman-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c26e6f22e255db14eab97ccbb29d6ea9b48d49ced5c61214a6c352255f1bcd4b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.19.1/atman-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "10b7a8a4a7fb8b664ea2a8c9a3b2abc9d750f465e92210b3f3dc9b9c685f1f1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.19.1/atman-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a91bdb74f4719dad78b2fbc3f2c2453a8323cd53ff648cebb6b644f1db6b2b33"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "atman"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atman"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "atman"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atman"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
