class CtrlKd < Formula
  include Language::Python::Virtualenv

  desc "Convert WordStar 4-7 documents and print-to-disk files to text, Markdown, HTML, RTF, or PDF"
  homepage "https://github.com/jonmichaels/ctrl-kd"
  url "https://files.pythonhosted.org/packages/0f/83/c668186acc7c055e1d6d74ffe733bc23058a0e7f0ba3abf784f9ba934b7b/ctrl_kd-1.1.3.tar.gz"
  sha256 "abda5bd6b467bbc4cefc0e2b9ac163fa5ee90c4dfdbd0bf0ad3330ed2b2c832a"
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
