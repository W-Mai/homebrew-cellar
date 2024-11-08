class IcuTool < Formula
  desc "Image Converter Ultra"
  homepage "https://github.com/W-Mai/icu"
  version "0.1.12"
  on_macos do
    on_arm do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.12/icu_tool-aarch64-apple-darwin.tar.xz"
      sha256 "958d79fbfc252c77856468d5cf4f27a7d452b1a8edcb3abc32de168ea4d952ee"
    end
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.12/icu_tool-x86_64-apple-darwin.tar.xz"
      sha256 "55da791a4551c25788a39ff72874eae74ca44bc088a4274ceb67a986539328ad"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/W-Mai/icu/releases/download/v0.1.12/icu_tool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fd0dfebd8c1f7ab93752f3290a359da77cd27b4c5b69809f13a404f8400acc3"
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
