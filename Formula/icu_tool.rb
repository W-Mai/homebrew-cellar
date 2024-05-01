class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.11"
  on_macos do
    on_arm do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.11/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "238d9109089c6a880a212e6e081b3542db9c4d5fd121fb515791f5309885366f"
    end
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.11/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "c43da7c1be5c82c63b2001c35b0444d6a35d3506f184a5bfe34cc292a768c5bb"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.11/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40f13b5d4ecb62c7a81d7af367c7ea12556c07344bcbada38a5564b8f4ff23d6"
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
