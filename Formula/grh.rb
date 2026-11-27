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
  version "0.16.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.2/grh-0.16.2-aarch64-apple-darwin.tar.gz"
      sha256 "53bb1a891d21a9f3027c0e39f5be44798b1e684bd961b591a8ae6aa08f6ec091"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.2/grh-0.16.2-x86_64-apple-darwin.tar.gz"
      sha256 "dd8393a1305104a12afaf0a63b5a01e8a9b2e3f228cf375833d9f46d401d85c5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.2/grh-0.16.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "12a21f905d9afe18abdda4fde1635327de906d784e0927ae713db70ec318bc20"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.2/grh-0.16.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "763a969aadde7938b48f3850b17b1768673bac622a2b22a13125b851cb39ed1f"
    end
  end

  def install
    bin.install "grh"
  end

  def caveats
    <<~EOS
      grh installs nothing until you ask, and shows its plan first:

        grh audit                          what fits this repository
        grh install                        pick the parts in a checklist
        grh install greengate greenbelay   or name them
        grh install --all --repo           or every part but the experiments
        grh uninstall                      take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
