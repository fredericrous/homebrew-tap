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
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.3.0/grh-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "5bda0eace6db6b3c3a063fa1103cd79005901ac2240603833e9a38336f66290d"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.3.0/grh-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "52536a066f451bf24220499ffcde0a81a9613c713ab3ab4c54cdd4d88fc23681"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.3.0/grh-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1eb6c97382212c0c5d86cb77504a2466abd1627fb2ba65bc9cc6040c49850052"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.3.0/grh-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "62bf41b70821de95314bf72055a4462c8309fdaa2aa447b17508c59c9ec26add"
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
