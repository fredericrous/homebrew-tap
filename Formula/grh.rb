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
  version "0.1.18"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.18/grh-0.1.18-aarch64-apple-darwin.tar.gz"
      sha256 "3a53852e5704f6767d158cf849147f89b5e57aec4a5d61f4a2f8a350a1575876"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.18/grh-0.1.18-x86_64-apple-darwin.tar.gz"
      sha256 "02565b154b22403195c7b46c2be85f980bd3fc6c5981d0a609728195b9e50456"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.18/grh-0.1.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d4c4fe999f4ae7450c646d9ba79bf18c52590fdf8063b5dc590695e4ba65456"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.18/grh-0.1.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "17ea5203ed46235750b040911ed4a7390dd2b052d9b553f0b6263139ca2960d4"
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
