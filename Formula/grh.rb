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
  version "0.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.3/grh-0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "229d22afa8dc1c95b784afd30674c1ceb01ac0e5a50d0d7d017f33c84a9c969f"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.3/grh-0.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "d4549db4550abaaaf2cbf02faea2db88c2428b908f6ee49821264f9ed9a781f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.3/grh-0.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "32196366528c12bb0926c58462794b13c38af5bdf0b37ac7e4626c15279c0815"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.3/grh-0.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8fb43edace5b7fa260684a042bb6b07c722e7a7ecdea094b59bf090650dd30d"
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
