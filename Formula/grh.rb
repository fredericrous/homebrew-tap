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
  version "0.1.12"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.12/grh-0.1.12-aarch64-apple-darwin.tar.gz"
      sha256 "5fc40b8861099778cec5aa3648f2820fe4753c8f4ff7617045fee4d1f1366ceb"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.12/grh-0.1.12-x86_64-apple-darwin.tar.gz"
      sha256 "7d2967daa119aef5812fd44f3a31b98baa2da9745042eb91b0422b86a75ca548"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.12/grh-0.1.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a78b54e44b9202b88e44a9e661f7c65e67912f2cbeb2f31830e0f955f5204d8"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.12/grh-0.1.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f468a6b6971a50ffac59d49eb22e0bd0ed40db03f1fe1178cb721c2725d8e2a"
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
