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
  version "0.14.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.4/grh-0.14.4-aarch64-apple-darwin.tar.gz"
      sha256 "df7003f961e41b310c73c43b341b7d7d9a7f44e32de72c43f13c4b865777a50a"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.4/grh-0.14.4-x86_64-apple-darwin.tar.gz"
      sha256 "5088ce29d46d93670ee59aad6c13be4a375ad4bb7b781c6d4a50e8f6f57c91a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.14.4/grh-0.14.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a39687d196336152fa0085451245e61c92586d0ed3f36116a0701b8afb7fa4c0"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.14.4/grh-0.14.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e15969337fda1295e28b0df93b765d6fa136aebf8c80a3d640b18fac6150e0c3"
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
