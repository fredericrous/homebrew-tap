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
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.8.0/grh-0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "f2d90426dbcfb711f4919e56bda2c964ef66a054458dfbade7ff99789a7ffd60"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.8.0/grh-0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "0b80900ee489bdca83432eb6cf6ab74dc88f96471659651856351aee00477f4a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.8.0/grh-0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "942f188a2713e2b8c3c72619b30e99b30b241dc71498daa2db983d06ae41e491"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.8.0/grh-0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6754c7319afaaa98633af39f4f9a9d48e82d473b82d6d5f1560195a6fb4eba9"
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
