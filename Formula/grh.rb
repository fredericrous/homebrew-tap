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
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.0/grh-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "6bab1fb9ce09188da18bd98c4138b2f2b8b1d69378986dae6944f4b71fe72b6b"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.0/grh-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "8e26dfae091bf7bee3d93b27f5eb22cf80ddef4fe46c96234c22ddfbd855634f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.0/grh-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "23975fbc53e77e57be37e993006c03f96099336677ebd23fe072823c0c9ff456"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.0/grh-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "76cc8fd2d0d3ca7d139a4fda51d0a7878e17264d90e9ad46ca5329cd7da773b5"
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
