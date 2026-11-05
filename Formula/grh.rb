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
  version "0.1.11"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.11/grh-0.1.11-aarch64-apple-darwin.tar.gz"
      sha256 "3623ccea3a10ec66ac5b192c46aaebdba73098df79e6c5e0ab2c48dc2ff28987"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.11/grh-0.1.11-x86_64-apple-darwin.tar.gz"
      sha256 "09bf7896537a25a5fb525584893c98ec26ac503d4c4e90dcc7370afda31c2291"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.11/grh-0.1.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca9ae8e0760e1ca7418dbad70c06b8ad4b41f731d810b8c3d10ae6b4f8652fdf"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.11/grh-0.1.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5af1df2d0580a150d0c1e11ab05f14805803c81c90bf127014b1deecef202760"
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
