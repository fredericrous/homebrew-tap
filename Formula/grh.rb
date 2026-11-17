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
  version "0.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.10.0/grh-0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "6350054dc0467f6da18694ded5a91f357f8c13a9b317e53dadef086656888d58"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.10.0/grh-0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "5bb340229c384f17abdbfaae6930cd547fe1352289fe476f65c4510cef8216ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.10.0/grh-0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f7d4582974cfdb5590999e0a6d79b105014f35bbae62e3e8cffea4f3bfaae8af"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.10.0/grh-0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cad7656118881c6fae2767c527cbc4cdfc32cd0c466c01c5f86002be930fefe7"
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
