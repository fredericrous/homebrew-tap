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
  version "0.6.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.2/grh-0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "280a377b1a0f994373a780c73a252ff3b9e72657f4b72272b6507f681fb09d23"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.2/grh-0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "7732fd4a83124de471c8ef9a94980e1bd7a7601b4f4a11dead81ecbb310aec3e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.2/grh-0.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d30b0527fffb4da06a5d7b35ea4f77dcdb9c4bdb1f559887a6b56b67bc2dffd"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.2/grh-0.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60a779089822889c4168e24b647fee011be426ce58866d1e43df6c7bcdd2d3c9"
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
