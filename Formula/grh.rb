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
  version "0.16.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.0/grh-0.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "5898677ae3f5e61d522a66b5fc4a1c2ecf10bc1c61aaf0ddb84346c217eef899"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.0/grh-0.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "b9f5e5b480e2ca6553df266e5613e1bddeb58d4155196c381072f75040c30418"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.16.0/grh-0.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf944e738177e3a7a162a815c5bc5577072fad565bf51a76ce06712644e37eba"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.16.0/grh-0.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41e776957aa643dfca473543fe8c83982089c0468896cfd7713fb507caaecf53"
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
