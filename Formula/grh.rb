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
  version "0.16.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.1/grh-0.16.1-aarch64-apple-darwin.tar.gz"
      sha256 "60f790fc4c696c7c62e630512fd3545cc21caea9b01213b5f4f2dab1d016e90d"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.1/grh-0.16.1-x86_64-apple-darwin.tar.gz"
      sha256 "0b7250e17284e49576969fed6130d923a6d35970ce0e4071ef35c51d82a39916"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.1/grh-0.16.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "950e0533232df26d1c6dba0fa5f6a81dd5ef5db5c8d90e975c66b5401f565243"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.1/grh-0.16.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce9d71fbe1c13b775e1e5af6dccf88d1522c7aa4d5338e7c3ee6112464f97c63"
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
