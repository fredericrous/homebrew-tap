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
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.5.0/grh-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "d8068c40d20c6f0d66733a746d671179982cfdc11c3cbf97a9606d0300634ee1"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.5.0/grh-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "7e97d9c15bb36fd37f16719ae5ca481d3b099c2dd59197c6c5ad7feb67107619"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.5.0/grh-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "885509a5b1dec9ca917cc039d4d2283bf1331f5aac0a13a8c06fde92075ca29a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.5.0/grh-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "36fe0e70da292cf888432b0e0dba264cc9fbc6a3b2d8bed3de77518f0cc11294"
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
