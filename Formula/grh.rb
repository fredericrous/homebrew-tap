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
  version "0.1.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.7/grh-0.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "4a8cdc18097f762d172b209ae291c19defaebd9660e5d99ce3a82f0902c737a4"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.7/grh-0.1.7-x86_64-apple-darwin.tar.gz"
      sha256 "f24ebf370c111f9a5a4152f16e2b07694ed8d6a09074b6921f6e18d01c38414f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.7/grh-0.1.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "240584379698362492e793b4c4f4dd22bc566f667a1175f2b22a39b7012055e4"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.7/grh-0.1.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ed5b58a56470c3bb666f8b9f3b218332a928fd8bb6309763a0e9c014f7e9de50"
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
