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
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.4.0/grh-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "90be2bc222c9f7f9dd07e7d5b764083019f7f5719c23964950ad978adb322245"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.4.0/grh-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "06897002e94b288a53c43487e0122f18710bd85c7aadf1ebd6e224782c574e71"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.4.0/grh-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "52127ad0c34eee47f1027f43abb206464dd43ce2b397bc12288f2c5c74ee0d4d"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.4.0/grh-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e98f670ec2aef59eae74c6e8b90ee46559caa9cf973830b20fcc77af7fe7d5aa"
    end
  end

  def install
    bin.install "grh"
  end

  def caveats
    <<~EOS
      grh installs nothing until you ask, and shows its plan first:

        grh audit                          what fits this repository
        grh install greengate greenpiste   name the parts you want
        grh install --all --repo           or every part, and arm this repository
        grh uninstall                      take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
