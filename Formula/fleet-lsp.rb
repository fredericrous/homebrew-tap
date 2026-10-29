# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.5/fleet-lsp-0.5.5-aarch64-apple-darwin.tar.gz"
      sha256 "ad8f94c0cb8e7130ebbff73efcd553c7376508605b979d433c7a7544d6ae41b2"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.5/fleet-lsp-0.5.5-x86_64-apple-darwin.tar.gz"
      sha256 "4437444c2dad4bdb9f75a28b50c8245865ad9ab67008e226cc4cdf046ef08af2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.5/fleet-lsp-0.5.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7b00ebda5f2f69531a703df16ca17df1fdac6dd977fedd4cd3d83cb5025f8f90"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.5/fleet-lsp-0.5.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3fdae3ee9c5d24903aea5247129c2f79d808fe5875b3fc35ca58345e542927a9"
    end
  end

  def install
    bin.install "fleet-lsp"
  end

  def caveats
    <<~EOS
      fleet-lsp is run by Claude Code through its plugin:

        claude plugin marketplace add fredericrous/fleet-lsp#release
        claude plugin install fleet-lsp@fleet-lsp

      then turn off gopls-lsp, rust-analyzer-lsp, typescript-lsp and
      pyright-lsp. `fleet-lsp doctor` in a repository shows what it resolves.
    EOS
  end

  test do
    assert_match "serve", shell_output("#{bin}/fleet-lsp --help")
    assert_match version.to_s, shell_output("#{bin}/fleet-lsp --version")
    # Outside a repository doctor refuses, with exit 1 and the reason on
    # stderr (since 0.5.0), naming the command that checks one repository.
    refusal = shell_output("#{bin}/fleet-lsp doctor 2>&1", 1)
    assert_match "not in a git repository", refusal
    assert_match "fleet-lsp doctor <repo>", refusal
  end
end
