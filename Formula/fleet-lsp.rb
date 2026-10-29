# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.6/fleet-lsp-0.5.6-aarch64-apple-darwin.tar.gz"
      sha256 "6b6f76f19a349417704531ed194f175721998ee50e29e02b648a792d87ba4435"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.6/fleet-lsp-0.5.6-x86_64-apple-darwin.tar.gz"
      sha256 "9e251c26e7549bbbfc483c20bdaf1e4a9c58a5f17b1b21497914c457bbeaab00"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.6/fleet-lsp-0.5.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4aa621b28422d3b1ff8f975172ff05f43be450315da4cf75b88995bbc2bd5e4b"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.6/fleet-lsp-0.5.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "772e889945d47181f496aa9b3fab48d242b18da0bbd2857324f99b34c880e176"
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
