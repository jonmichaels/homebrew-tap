class Sr < Formula
  desc "Soft Return CLI: convert WordStar for DOS (v4-v7) documents to modern formats"
  homepage "https://beforeti.me/soft-return/"
  url "https://github.com/jonmichaels/soft-return/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "05065cd2935067345c77dde87ea45d82219b2dfcb877a5a77e72ca98da6dfbd0"
  license "MIT"

  on_macos do
    depends_on xcode: ["16.0", :build]
  end
  on_linux do
    depends_on "swift" => :build
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "sr"
    bin.install ".build/release/sr"
  end

  test do
    # a WordStar print-to-disk stream is plain text with hard CRs -- the simplest
    # real input; conversion proves detection, parsing, and the text emitter
    # (sr is byte-parity with ctrl-kd; same test shape as that formula)
    (testpath/"LETTER").write("Dear Reader,\r\nThis is a printed page.\r\nSincerely,\r\n")
    system bin/"sr", "LETTER", "-t", "text"
    assert_match "Dear Reader", (testpath/"LETTER.txt").read
  end
end
