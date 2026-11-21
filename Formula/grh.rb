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
  version "0.14.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.3/grh-0.14.3-aarch64-apple-darwin.tar.gz"
      sha256 "8b847d38aa7b14947365161bfe3ec82b9e8abaadc62df38d72706e5b9da2d7b3"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.3/grh-0.14.3-x86_64-apple-darwin.tar.gz"
      sha256 "f2463b561a5c1415a790a13f02640332e5a473530679207087e89dfc49261e32"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.3/grh-0.14.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0eb1b3200b1a1bcc5884e29fc77a1061bd12e3e0e9c623ca255ed37167ff5b2e"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.3/grh-0.14.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10f5931db871afb16b4e6225bf087dbccc2620a6d92f1c3c0dc97480e5aa7347"
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
