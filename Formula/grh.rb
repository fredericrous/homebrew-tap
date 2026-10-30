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
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.1/grh-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "f6ef11da5f6c8265376b7ae3f2ee67d80b4805f8953636f1ca1342367de8d236"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.1/grh-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "58997d53647fa9267640373542dcfe841acc84388700639ab05c5b371ea5ab9e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.1/grh-0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e56a93fa1db4f851a987a310360dc03e8f5e341285eac27f9ed83a271aff9e63"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.1/grh-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "84774211a77ececcd7d201995e8acfce85356a3f005ce9fce039ec1424c06dc4"
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
