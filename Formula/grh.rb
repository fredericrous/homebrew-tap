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
  version "0.1.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.9/grh-0.1.9-aarch64-apple-darwin.tar.gz"
      sha256 "a83b5667c9a02b885b6a6e884e81c7a81da3516b197f0d5711cbf41d4058a7d5"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.9/grh-0.1.9-x86_64-apple-darwin.tar.gz"
      sha256 "c87d578d0b1585029472b7c558cf05a131c320f1d19d448eccfb7f5b795d2228"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.9/grh-0.1.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3df28aa6b329545015c01e1a05163359ba7d8c4357f76771bcdc1ba304a3862a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.9/grh-0.1.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc5eb8193ff34b9c183fea029f0c8d424a496ad8b0e3bcf5a2cbebd7cbcc9f8a"
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
