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
  version "0.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.8.1/grh-0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "091b4f466099716c92e54662defbc4f2744a76f18001ebf5fee36c35bed5cefc"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.8.1/grh-0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "27d02c10d3179c62f4ec5837f6341e8f75afd913d2cce1deeb6e03b916754f5b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.8.1/grh-0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "00924fdb0a8b7292797122a2620d5f3158f3858f410ceda33712e1a6b73cdec3"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.8.1/grh-0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "50763b738a8a52c632baab111299f07ddde7920d6508975a2934e1da1c8db7d4"
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
