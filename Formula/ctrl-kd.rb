class CtrlKd < Formula
  include Language::Python::Virtualenv

  desc "Convert WordStar 4-7 documents and print-to-disk files to text, Markdown, HTML, RTF, or PDF"
  homepage "https://github.com/jonmichaels/ctrl-kd"
  url "https://files.pythonhosted.org/packages/a3/1a/8fae85fdf02a30e1ec8f6c01128e2916b3905a807d5e90611f0d20fb96e0/ctrl_kd-2.0.0.tar.gz"
  sha256 "d69ee7b6a87573fe5daee0a07834a54017d7b250bf0c5accb1e267e7499112a0"
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
