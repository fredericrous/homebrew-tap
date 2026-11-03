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
  version "0.1.10"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.10/grh-0.1.10-aarch64-apple-darwin.tar.gz"
      sha256 "e2be6e03b6ef5fc5d0c9621eca29d9dcd5d8a04df081b154b5329a3aee87b4ba"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.10/grh-0.1.10-x86_64-apple-darwin.tar.gz"
      sha256 "96966be23d981b0529999e201f66faa7c5643185c9a6df5f5b5c0ac34cecf751"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/grh/releases/download/v0.1.10/grh-0.1.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9586171c38e042a6bf553ed0cccc0eaa2778cdec3acc05857a4927cdae365bea"
    else
      url "https://github.com/greenharness/grh/releases/download/v0.1.10/grh-0.1.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eb192d7258e052741c6ad1e299c388ab989db07595f76327f08bb13d14e46922"
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
