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
  version "0.1.15"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.15/grh-0.1.15-aarch64-apple-darwin.tar.gz"
      sha256 "14b7d8b3d9accc9d68254e77d760f83625935449cb724eecc400be1e6816f032"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.15/grh-0.1.15-x86_64-apple-darwin.tar.gz"
      sha256 "e24d6e386852f228cad609a9104399a4568b5f52bd9be8bee6b00882ad912b71"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.15/grh-0.1.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d05aa05e65b489265bf967ee436ac090a4ff8d94aa0a0c13bacd7191eb7d2944"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.15/grh-0.1.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9e389c86f3282205a588472d4d030334fc71e842ce2ef7c9758ab171d4929745"
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
