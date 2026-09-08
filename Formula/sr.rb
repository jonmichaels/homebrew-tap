class Sr < Formula
  desc "Soft Return CLI: convert WordStar for DOS (v4-v7) documents to modern formats"
  homepage "https://beforeti.me/soft-return/"
  url "https://github.com/jonmichaels/soft-return/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "05065cd2935067345c77dde87ea45d82219b2dfcb877a5a77e72ca98da6dfbd0"
  license "MIT"

  on_macos do
    # CLT-only floor: Homebrew's depends_on DSL has no way to pin a Command
    # Line Tools version on its own -- depends_on xcode: [...] pins a full
    # Xcode.app version (Formula-Cookbook.md, "Specifying other formulae as
    # dependencies"). sr 4.0.3 only needs a Swift toolchain, which the CLT
    # package provides, so express the requirement as a macOS floor instead.
    # Xcode/CLT 15.0 requires macOS 13.5+ (Ventura) per Apple's Xcode 15
    # release notes, so :ventura is the lowest macOS version that can
    # install CLT 15+. Dual-platform formulas put the macOS version
    # requirement inside on_macos (Formula-Cookbook.md, "For a formula that
    # supports both macOS and Linux but needs a specific macOS version").
    depends_on macos: :ventura
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
