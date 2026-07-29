class CtrlKd < Formula
  include Language::Python::Virtualenv

  desc "Convert WordStar 4-7 documents and print-to-disk files to text, Markdown, HTML, RTF, or PDF"
  homepage "https://github.com/jonmichaels/ctrl-kd"
  url "https://files.pythonhosted.org/packages/0c/04/35a51fc8b58df6573d5d5dc52607b38260b367a16ddde1b68b14ef0187e1/ctrl_kd-1.1.2.tar.gz"
  sha256 "9a52d3e6445f8d0f83aa1d970385fd285c65892c9e55d2d6a3c4a235ff262482"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    # a WordStar print-to-disk stream is plain text with hard CRs — the simplest
    # real input; conversion proves detection, parsing, and the text emitter
    (testpath/"LETTER").write("Dear Reader,\r\nThis is a printed page.\r\nSincerely,\r\n")
    system bin/"ctrl-kd", "LETTER", "-t", "text"
    assert_match "Dear Reader", (testpath/"LETTER.txt").read

    # --diagnose reports what a file is, as JSON
    assert_match "printstream", shell_output("#{bin}/ctrl-kd --diagnose #{testpath}/LETTER")
  end
end
