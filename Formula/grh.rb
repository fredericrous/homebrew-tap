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
  version "0.1.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.4/grh-0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "f6cb86313d69c78cace366a3ca1f6c04e443f1bc9e7a9798ea4f9c45717707a4"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.4/grh-0.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "8032ad5d80492739704156bd63938697d0f32dacae063d37a9c26cdce90d9cbc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.4/grh-0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d20151f1cf297dba1bfbb0c5320a1dd39cd7f5b8135fc18bed7dadb8b3d49e13"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.4/grh-0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c1c7a7a0c655441a281c4f03857f910082c1d1647647f277c6f08f1456483309"
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
