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
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.2.0/grh-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "7b6566f5e7f4c4b73c11a3f96301196d9da7a8a9372b7e3ccc6389b76317099b"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.2.0/grh-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "89eb21db09385bed0e2e194eb3d25e9a1554140ebb0674b91a74008487d24e1b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.2.0/grh-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e6e166777eb3faf42bb7a74978b7bc04fffb1089fcd8b7e7e57bc67487486a6"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.2.0/grh-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "751cc48d4d6607dc907c4215caac2a06f0ade6a7b96a5b39f17e1bd9d41fd2ac"
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
