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
  version "0.6.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.1/grh-0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "ab64d8570b5cb39a4f66bec9baad334a9d7c03214de3853e40d7711fc8b24df8"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.1/grh-0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "1eb3805206866128e110ad23cea70f864af796a415083f8188cfdf58812cb9b3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.1/grh-0.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "673908e388db66aff947f19af94f7360ac3025905596c41ed6a344da1707a626"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.1/grh-0.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5def626e3af2fd8ccd3a39fc77354a9e37e170f0dca3e4b475476eb6da09e9dc"
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
