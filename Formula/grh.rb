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
  version "0.1.19"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.19/grh-0.1.19-aarch64-apple-darwin.tar.gz"
      sha256 "7dd138502cc15b3119d2fa940c84390e0ea43163da71942466a7cd2acbfc536b"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.19/grh-0.1.19-x86_64-apple-darwin.tar.gz"
      sha256 "724387f64767627178aa7bc950cf930dbb3a1b0524500463f3060222c06e7c26"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.19/grh-0.1.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9cb42cda8ff1f782b2fc78981b325a9a18f225dca25f3c0d93b83f43eaea6951"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.19/grh-0.1.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6656776e2facb3dfdaf1e812b8dfd3f24fe2ac61fded8407c297997ebba69f79"
    end
  end

  def install
    bin.install "grh"
  end

  def caveats
    <<~EOS
      grh installs nothing until you ask, and shows its plan first:

        grh audit                  what fits this repository
        grh install solo           gate and guardrails
        grh install team --repo    + decisions and conform, and arm this repository
        grh uninstall              take every part back out
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grh --version")
  end
end
