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
  version "0.13.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.13.0/grh-0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "d5cce078d6686216778ee9398113fae65a62bf0afd6b144e61fa0e40937c2a72"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.13.0/grh-0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "1e81f3f740bd787b7ee2a6ec1ccf3be9d314e548bad9370ec99e2e294b4d9d7f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.13.0/grh-0.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21137d70fbb97f92b36af99478a3b1c6573fd015197bbb371511c03ab2f6e358"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.13.0/grh-0.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9443701ed6bb8b12d64ef655095b7d180b43d41ad15a0e22edc658e46d77bc98"
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
