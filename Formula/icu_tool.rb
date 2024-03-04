class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.8"
  on_macos do
    on_arm do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.8/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "ce9aa1988faeece8e3abb1103ee2409a24a3ffac9d66e6421a75e05ab455541a"
    end
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.8/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "d4cf37ad9a199a214001383c374250ee05467b0a263a919cb8f00a78270e6e8f"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.8/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd7e0c9411c18d0cfdbd2060b23e14bc0e6ebf28062eece499a6ef4b91a7447a"
    end
  end
  license "MIT"

  def install
    on_macos do
      on_arm do
        bin.install "icu"
      end
    end
    on_macos do
      on_intel do
        bin.install "icu"
      end
    end
    on_linux do
      on_intel do
        bin.install "icu"
      end
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install *leftover_contents unless leftover_contents.empty?
  end
end
