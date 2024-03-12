class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.10"
  on_macos do
    on_arm do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.10/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "d813ba452421eb1253a7389717fbe08073c136a22dcc9035048dbb688e4256ae"
    end
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.10/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "434001ac6c76d8afaaef94118f678d66a968061a7a825800764c9fd8108f6038"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.10/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c81398c6824c9be663fbdfb4b94839a9876fd6b673f6c74a88b7293d6d7abcc"
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
