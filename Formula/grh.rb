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
  version "0.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.11.0/grh-0.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "ba3f60a5bbe00a428df40dc5f68cfee08d774821cc2d00cac2b48e5cabf0397a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.11.0/grh-0.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "ca748cb758cc94c50d596831e24629d6a9fcf2ca716b0b071b0cba76c080785d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.11.0/grh-0.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60d0d3b47172cece4eb3d8a2ca6e7b6cb541e6c5bd314db94ff6cd57c7c29389"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.11.0/grh-0.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd42973421d7bb27fa964b5ddb899e2d411d4004b4d06a62ec9cbcb2e3c3602d"
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
