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
  version "0.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.1/grh-0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "44e13ac3e5dae51076fcc57b7829b80a1f6fbb7b668c88a83da3a2ce4b9e37b1"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.1/grh-0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "9034508f976d41e30a0dc3b6e0e452513e2f1cb4875e4f61861a6f3b7c97dd66"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.7.1/grh-0.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f79ffa313f9f331c78bfd55e09657cd9d950cb8342262c593034636e11a44b55"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.7.1/grh-0.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d4b2af40d9276e8092350b351c06b9c67eea7594cb32aa11e1d14f656049df17"
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
