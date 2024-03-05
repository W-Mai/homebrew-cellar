class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.9"
  on_macos do
    on_arm do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.9/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "7c068275fdd38378c1421ed062a70cd018910643280588324dd2be8cd53fa7a1"
    end
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.9/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "fa50941ee4022635740946bf4a2594195c3e27453b42f7f4111abd0a59892ccc"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.9/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e086c6eb87caaa5ac3ed7182237ca0919154e636b1fe606867afa6bf720ef13f"
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
