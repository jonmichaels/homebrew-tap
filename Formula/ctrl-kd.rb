class CtrlKd < Formula
  include Language::Python::Virtualenv

  desc "Convert WordStar 4-7 documents and print-to-disk files to text, Markdown, HTML, RTF, or PDF"
  homepage "https://github.com/jonmichaels/ctrl-kd"
  url "https://files.pythonhosted.org/packages/fc/ed/d70542b58e19404d999b297330bc6e7845584c7ce71be24388c51ffbbc6d/ctrl_kd-4.8.0.tar.gz"
  sha256 "5a7d9aaa44e73e1bab06e1a79500247b14d4691a46c86f2eb928f5cc508f15ae"
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
