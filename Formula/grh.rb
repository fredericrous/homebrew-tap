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
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.0/grh-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "a7802539efbe1d18c267d55c5e3c76ecc1c51ddb41aae3a3d9f89c63b735d2d4"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.0/grh-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "32e7887c2161c1b58223c29f5c932f074c3aa2f210b4d2a8e05890d3dbb276de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.0/grh-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "721048040f6a69dfc2e710b528493bdaf1805df86a093c0b12cb023025e9cae0"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.0/grh-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f575fed11ff411f39dabfd86f8f0adbda961b62cc97104f13b023be4f500b525"
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
        grh install greengate greenpiste   or name them
        grh install --all --repo           or every part but the experiments
        grh uninstall                      take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
