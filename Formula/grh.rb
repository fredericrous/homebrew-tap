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
  version "0.1.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.6/grh-0.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "e0d1edf3e5c878487ef201c40737768e54bada84fe520639b13ca93900e2b716"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.6/grh-0.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "671ef28b18b5ab7543bff902d1dab489be8c2cd25dfde29053eb4e0622e36631"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.6/grh-0.1.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2331e0f59dae45c60c3936687549e23bd370d0ad5f8badb1bee22a4230a4b781"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.6/grh-0.1.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "37480f6a0c9edf5e5951e373407eb782ab08bfa1656523bd595f151441298d45"
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
