class Sr < Formula
  desc "Soft Return CLI — convert WordStar 4-7 documents and print-to-disk streams"
  homepage "https://github.com/jonmichaels/soft-return"
  url "https://github.com/jonmichaels/soft-return/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2ab1b96d967a33473b2b2ea8ed50c639b4eef125b0c9bf1cab454d9c8b447718"
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
