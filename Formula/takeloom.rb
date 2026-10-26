# Updated automatically by takeloom's release workflow
# (https://github.com/priestc/takeloom/blob/main/.github/workflows/release.yml):
# each release rewrites `url` and `sha256` below.
class Takeloom < Formula
  desc "Music recording session manager"
  homepage "https://github.com/priestc/takeloom"
  url "https://files.pythonhosted.org/packages/source/t/takeloom/takeloom-0.5.0.tar.gz"
  sha256 "3c53f6b6f404f415ef6f14a929137a1a9b820c2093b1104434871812cbfccfbe"
  license "MIT"
  head "https://github.com/priestc/takeloom.git", branch: "main"

  depends_on "fluid-synth"
  depends_on "hidapi"
  depends_on "libsndfile"
  depends_on "libusb"
  depends_on "portaudio"
  depends_on "python-tk@3.14"
  depends_on "python@3.14"

  def install
    # takeloom in its own virtualenv, like pipx. Unlike homebrew-core, a
    # personal tap can let pip fetch the Python dependencies as prebuilt
    # wheels (numpy, opencv, ...) rather than building each from source.
    system Formula["python@3.14"].opt_bin/"python3.14", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", buildpath
    # static-ffmpeg wrongly lists twine (a PyPI upload tool) as a runtime
    # dependency. Nothing imports it, and its nh3 extension module makes
    # Homebrew's ad-hoc re-signing fail ("Insertion at offset ... is not
    # valid"), so drop the chain.
    system libexec/"bin/pip", "uninstall", "--yes", "twine", "readme-renderer", "nh3"
    bin.install_symlink libexec/"bin/takeloom"
  end

  def caveats
    <<~EOS
      To open Takeloom from Applications / Launchpad / your app menu:
        takeloom install-launcher
    EOS
  end

  test do
    assert_match "Music Recording Session Manager", shell_output("#{bin}/takeloom --help")
  end
end
