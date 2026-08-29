class Sr < Formula
  desc "Soft Return CLI: convert WordStar for DOS (v4-v7) documents to modern formats"
  homepage "https://beforeti.me/soft-return/"
  url "https://github.com/jonmichaels/soft-return/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "ef8c636ed34b7cb509db5b6436ded2455b917bc6c49f8400029f8714314e7d40"
  license "MIT"

  on_macos do
    depends_on xcode: :build
  end
  on_linux do
    depends_on "swift" => :build
  end

  def install
    system "swift", "build", "-c", "release", "--product", "sr"
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
