class CtrlKd < Formula
  include Language::Python::Virtualenv

  desc "Convert WordStar 4-7 documents and print-to-disk files to text, Markdown, HTML, RTF, or PDF"
  homepage "https://github.com/jonmichaels/ctrl-kd"
  url "https://files.pythonhosted.org/packages/ad/9c/ada43735f91b4ab4ff5ec8f4d97b4678b238ddef2579271df27bcde936ff/ctrl_kd-4.0.1.tar.gz"
  sha256 "d6dcee9eaa07314b78101ed988941f97075dda0446343e56eb29aa980132e9dc"
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
