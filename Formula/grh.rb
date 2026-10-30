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
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.2/grh-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "dfea5b769fc4e70e89970f8fe6e4583ff20aef2ee7b4be7062eb763d3c81be62"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.2/grh-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "87b58a1f6dcba2bd4ca35dea7bde728e5c9cc0f5e56bdc199f3ea9b9b3a96bc9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.2/grh-0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bab754bf7ef805443768dde2f78d50fb18bdac179d4067bb907194afe310e2dd"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.2/grh-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6344f4d8dd4f13b7e4eac3cea040cbb0cbd7cc149e618b6e43ae0103420f5e79"
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
