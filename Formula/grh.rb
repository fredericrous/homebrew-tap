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
  version "0.1.13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.13/grh-0.1.13-aarch64-apple-darwin.tar.gz"
      sha256 "253daa068c022146b40de79b1fa845306e8ac04a5fdbf697ab738df6f5b54db8"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.13/grh-0.1.13-x86_64-apple-darwin.tar.gz"
      sha256 "fd397f2fc0f0b40f6c8e480c24c09d42c32ae3620fda03fc104c82ea6399eed7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.13/grh-0.1.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d6c37e7f46de51efd15a08e393ed60f0807007b48da22b24240831b282258e2a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.13/grh-0.1.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0eb4221fb92fbf7cb7e7cc3511601c32cf7c6d2d940113ab6da9e28746aa33f"
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
