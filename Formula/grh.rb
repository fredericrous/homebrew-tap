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
  version "0.15.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.15.0/grh-0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "21df23aa2e25a80717a59a87a6218bfa650f276ad31d0bd61a2d0dbace866567"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.15.0/grh-0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "b913c91cbcea88333249622bf7ca16dd31b253baebcd9097ff35355221eed7bb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.15.0/grh-0.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6237f48cfb65ea6e97bbd3bac8b90c70c064e6b8db0dff33dafe3ace20d5372f"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.15.0/grh-0.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f6a8d4ba4c99a66abf3629f5bcb20492c7049a05933660c3d56c91a5723d2f83"
    end
  end

  def install
    bin.install "grh"
  end

  def caveats
    <<~EOS
      grh installs nothing until you ask, and shows its plan first:

        grh audit                          what fits this repository
        grh install                        pick the parts in a checklist
        grh install greengate greenbelay   or name them
        grh install --all --repo           or every part but the experiments
        grh uninstall                      take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
