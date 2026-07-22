class AtmanDaemon < Formula
  desc "atman headless daemon — Unix socket + HTTP SSE server for the atman AI coding agent"
  homepage "https://atman.run"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "b667d3b48e2fa0563f0fb6087046136014e9f0df3d36f5058a39d2f4135c86e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "962c9b6a3e2bc7009601110e2a667b18a8a31f30b9c52e37599feea99598c953"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b19630cf1f3ed36619bad46c9dd6ba6b8c0a68f2ade8f017a960b9fecd48e5be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/W-Mai/atman/releases/download/v1.1.1/atman-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a47c90e5c2faa5dd1e3fe956ab293affb9e9683afd57f186580a2ff529d729e1"
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
    bin.install "atman-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "atman-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "atman-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "atman-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
