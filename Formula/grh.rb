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
  version "0.1.14"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.14/grh-0.1.14-aarch64-apple-darwin.tar.gz"
      sha256 "6e247c5dc253ea1020ced511a17c79d3f5e1141efffff1bd118f7c10272b9f64"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.14/grh-0.1.14-x86_64-apple-darwin.tar.gz"
      sha256 "7c72e25c8476c4ed75cfe2a3c154a0ff94b64eb50021a244d57e0ef7c41300ef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.14/grh-0.1.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eda6ab859ad9073b7270fb417753251681273dcd3415e46f40cccfd2d8f06b23"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.14/grh-0.1.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "801c04de08b6f0b381c729cca78e0bd8edd89d347897d9038308966e3fd5f091"
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
