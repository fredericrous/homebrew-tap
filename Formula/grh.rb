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
  version "0.14.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.0/grh-0.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "0385850b6179d8db790eda341f33dd8c5399c0ba8c481a6b531cff21e8b7dd5e"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.0/grh-0.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "9222a6457c726008bb02a6e0d75d8ecaf9d3b846a0db5bff89960e1b34bad6df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.0/grh-0.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d9a890259a51c4e390732c4cd8eadec998ad531b3007e9a29966bcee9295bf2"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.0/grh-0.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7e225d1278370df15e7896b0afc126a23a4dc9e07e4757931af2233231074883"
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
