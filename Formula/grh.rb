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
  version "0.14.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.2/grh-0.14.2-aarch64-apple-darwin.tar.gz"
      sha256 "1c0cd3ccd2ddfc63bda8f75ec96839612de266801c6dd088db0293b1ae5d58ee"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.2/grh-0.14.2-x86_64-apple-darwin.tar.gz"
      sha256 "a1d1efd4c12b3ac30ff7e9ff61f9f37f95e6c30272347d9cd83e3eebf8a8c4bc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.2/grh-0.14.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0442e692fee742c5af695c2a9e336cf3dd9c1c39d33c595507a219891e2aee4a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.2/grh-0.14.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cb7344478d25ba870d76d7c661dea97b4dcfcc86d9aae657e41008e8cd69390a"
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
