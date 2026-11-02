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
  version "0.1.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.5/grh-0.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "df99b6fca2036931c260aa9a7ccd225e25602681d04f9762d89d81485361e702"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.5/grh-0.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "4e3a5e7766b3e599281fd20bc9ba0fc9adcd3359343b9b40fffb1ebdf94a2d51"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.5/grh-0.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "893cc0205e9ea5c500ed688a55fa4285ba93462ce56a88348680ea2cb215aec3"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.5/grh-0.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fcff3d75fa71eaa84fd57dbe8832d8f72b85e28b04ab4708aa1d8ec67e035f3f"
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
