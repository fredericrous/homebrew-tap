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
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.0/grh-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "533052d27990541f56652bf979324abc171b20fd562f083963ea79f58b0311e0"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.0/grh-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "5ded69b7627ee5a9e02473bbaa60766eeb863542d4f57e721876af59d281665a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.6.0/grh-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b493ff37cdd9ce33eacba0e2c71cdb54e1ce9faaeb6624094e6cfc6bdb1cdf6b"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.6.0/grh-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a170975bf483c792ed9a883c6c5a39c15ef48bb3313c1af189736f32dc81f1d"
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
