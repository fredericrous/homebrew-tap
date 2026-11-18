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
  version "0.10.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.10.1/grh-0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "3d0fa3cd8f9e322d62aaebe3e790801d1c0c2aff34f0b321aef03e68a4b328ef"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.10.1/grh-0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "76545e65d6ea7b8e53de286f82efd0d4d69c3232a241cb25dcd5b964cfb465c8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.10.1/grh-0.10.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8f78d5b88e0b8d65641c00842ae51643df2fe250f9c788836073d04affd1db7"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.10.1/grh-0.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f6baa0dae2f305a88d6320e2348d01488a052a3de7a6e547d4f724b270238137"
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
