# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.4/fleet-lsp-0.5.4-aarch64-apple-darwin.tar.gz"
      sha256 "4b50bb42000635493461474f1da1b6fe23dfdfacc41ba9df575c2794251a2a97"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.4/fleet-lsp-0.5.4-x86_64-apple-darwin.tar.gz"
      sha256 "17e82a38ed3a8612644cbc5eef48b396602f2a0fe42431310d8f6e6f1903a133"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.4/fleet-lsp-0.5.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "053114a3027dee09a0b0b9a88cdb12293e189755e3db871dc593a828ab3522f6"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.4/fleet-lsp-0.5.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b24316edf519a3890d1da77f250c6222b99b47e385d40986218af4bacee4e83a"
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
