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
  version "0.1.16"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.16/grh-0.1.16-aarch64-apple-darwin.tar.gz"
      sha256 "db96ceb619a2f75e249b6403d4c89084fade163e08419b1fd6990c658101ecfd"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.16/grh-0.1.16-x86_64-apple-darwin.tar.gz"
      sha256 "a130473e908cf3b002e70f7d94b2d0885a2742bd932ea47a729744c848b1d0f3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.16/grh-0.1.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86d43bbf1c34043051ceef3faaadd74b72988eabdadda389df11aa28ec0182c9"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.16/grh-0.1.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "210f61907d1bc17a92b4f72d0d069bea110fdd1e9d9a3f32a62111188ff6503a"
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
