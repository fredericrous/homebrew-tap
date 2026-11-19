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
  version "0.12.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.12.0/grh-0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "7264c3f9e3d2e6fe85c75c12d47834f2b030f323590eff55f1ebb296c2a68f88"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.12.0/grh-0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "1bfe7e2df5cb4e0c607edb180c57052fb8d9dbc635e0d9c1179f4a2c86be22bd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.12.0/grh-0.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87b499571c9402120f2eb26d70950b9cacb47356f1f8e52400ffb0c25559297c"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.12.0/grh-0.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5bf69a317fe266785cca5a2a09ece7ce4e26e9d857351719024c7857382c8332"
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
