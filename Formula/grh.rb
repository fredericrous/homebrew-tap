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
  version "0.1.17"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.17/grh-0.1.17-aarch64-apple-darwin.tar.gz"
      sha256 "5ab5b1a0d3a183c7848f26bada8adfa7c7bf1a0ea94393f2f5dc0928fcac78ff"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.17/grh-0.1.17-x86_64-apple-darwin.tar.gz"
      sha256 "3093339818fad2bc9f91a6387b6607d032ada29b2b35a9d8159ce436c9edb103"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.17/grh-0.1.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "52ccf8a36ece14abe45b160a314ab1bdb50873254ed54243260987d8c0a06101"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.17/grh-0.1.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8b6ff357dbfa12c64f01e3f9d5fefe4ebaabd5d3a71780acbd1d09da05794131"
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
