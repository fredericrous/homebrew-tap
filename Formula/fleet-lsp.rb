# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.1/fleet-lsp-0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "8d15a987a406d34e3aa4685fb9dd10ade9b42c1b5192c41ca2b1e1b1ad09b153"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.1/fleet-lsp-0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "c34969938b068471030338466f370398ec03fb978b85c0de43079c1c2f3c2637"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.1/fleet-lsp-0.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7f287a58764adc4d63704e888d97c2a9d6405cd483538380f172e4563849a685"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.1/fleet-lsp-0.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93ac7bbf2fbd7d305763f03d364970edb55abca07016d6df2b2343b7aab188c8"
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
