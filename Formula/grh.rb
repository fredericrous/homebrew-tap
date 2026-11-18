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
  version "0.11.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.11.1/grh-0.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "4e54b3ee4f0930a714056f6f8362b30b9d31379379f806f7207a07c2cb805a50"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.11.1/grh-0.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "8f5958304cc164877354a817a64a60322835b588c9aa15d42f18780365651466"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.11.1/grh-0.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "86718dd9270e11703a0c11396b7f69b0319e2a42b94bffd4e6b79e4b8f824aea"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.11.1/grh-0.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f529fc35fb9a38196a8b148633da7becec7164f6641a167fae3a0fc5536ed7f3"
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
