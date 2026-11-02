# Homebrew formula for grh, the Green Harness installer.
#
# Prebuilt binaries rather than a source build, for the same reason the other
# formulae here give: the release workflow already builds, checksums and
# attests them. The sha256 values below are the ones published in SHA256SUMS.
#
# Keep the shape the bump scripts assert: four url/sha pairs, one `version`.
class Grh < Formula
  desc "Install, audit and remove the Green Harness parts"
  homepage "https://github.com/greenharness/grh"
  version "0.1.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.8/grh-0.1.8-aarch64-apple-darwin.tar.gz"
      sha256 "81eb73ddb842cab42ce170de83071a535d7687db58fd8a211503721efee2ada9"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.8/grh-0.1.8-x86_64-apple-darwin.tar.gz"
      sha256 "83ac7eeb2b4a4e87e3dffce61bc7bc49738f7b08b9fee1750967203b1ff8783e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.8/grh-0.1.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6aeb72d2c79f0ff74c0d7f6990078ce02024d6649a83377e33a2f6353b041129"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.8/grh-0.1.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ea3304eacbe8ecf0cad4f75a12820670b0ddc4b2c445f6abd9f2153c79ed973"
    end
  end

  def install
    bin.install "grh"
  end

  def caveats
    <<~EOS
      grh installs nothing until you ask, and shows its plan first:

        grh audit                  what fits this repository
        grh install solo           gate and guardrails
        grh install team --repo    + decisions and conform, and arm this repository
        grh uninstall              take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
