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
  version "0.14.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.1/grh-0.14.1-aarch64-apple-darwin.tar.gz"
      sha256 "76459a6f06af1b1dd211045ba4490c367a42fab6feecfc9141914739ee24d49c"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.1/grh-0.14.1-x86_64-apple-darwin.tar.gz"
      sha256 "366f26f12b200a3acc1db103d2aeadf3f0e9cdf41c71e20d6f343ae0a9a608cd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.1/grh-0.14.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be790187d2a1940f1083d6308207ff733660e8a2458cf7a76f5044a8291a0e9f"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.1/grh-0.14.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "71fa56f0cda3a90ecbbb9f85185ecdf82d4673d4450ae1925ce4711a44009cbb"
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
