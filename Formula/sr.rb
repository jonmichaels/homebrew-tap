class Sr < Formula
  desc "Soft Return CLI — convert WordStar 4-7 documents and print-to-disk streams"
  homepage "https://github.com/jonmichaels/soft-return"
  url "https://github.com/jonmichaels/soft-return/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5d4c9e922ac4cc94f62b9df2a5fcc8e0bf2605b0a7b24e6470556f9ba7499eda"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sr"
  end

  test do
    assert_match "ctrl-kd parity", shell_output("#{bin}/sr --version")
    (testpath/"LETTER").write("Dear Reader,\r\nA printed page.\r\n")
    system bin/"sr", "LETTER", "-t", "text"
    assert_match "Dear Reader", (testpath/"LETTER.txt").read
  end
end
