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
  version "0.7.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.2/grh-0.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "b78a75ce321542386e1e39be85643df773572c75f652d8158ddd34e19877c21c"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.2/grh-0.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "3e2bd1dc59e3ae658f4858e3d15e95ff4a361001d1ff8c9af706457e2c3e2157"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.2/grh-0.7.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a89114d8149b58f17ab19fa76f4d58b08274b13f5371741d8da300bca15cee5d"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.2/grh-0.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b0482215b00279cfe0ffcf7ef31afab0b967e689aff85f18728fc0b2209b3e95"
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
