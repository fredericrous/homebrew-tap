# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.6.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.2/fleet-lsp-0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "c9a99068845820e8460f3ef24539f14a4ba6c405646353e2cfc1d8ba22b41480"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.2/fleet-lsp-0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "cb4e35bcaf6b5a52d5f8eda841aa47b67a620a776bc8b4f5a6ed561c7879b42a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.2/fleet-lsp-0.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24469b79b1858df50c1b768caaaa32ccbe325865b8e252dbc8aefb629fc8c145"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.2/fleet-lsp-0.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4760250d25caf3b455a88b95c7df07ab957e45602ce2c3f6b58ea1afa61c900f"
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
