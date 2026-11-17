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
  version "0.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.9.0/grh-0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "648284c909494d3b42375d4f244089a65a87805cb813941995439f6fdd4acc9d"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.9.0/grh-0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "5355caa024d0d172a86d00f5733aa54a01294724fcefa7c1ba7a849c30fa934d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.9.0/grh-0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9bca149e003b8ab6ac0310df55ffaef03527a139dceb2cdac4f1e02525395976"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.9.0/grh-0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7485dc50deffc1d5c4733e1a805ccf254c06bbafd64d0865fe13f0c8b14b9bdc"
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
        grh install greengate greenpiste   or name them
        grh install --all --repo           or every part but the experiments
        grh uninstall                      take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
