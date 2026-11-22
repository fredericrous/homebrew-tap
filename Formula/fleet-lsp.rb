# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.0/fleet-lsp-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "5db7e25ad3b0c316083378f5742ac5c61c54e36e5f7874b6614f6befa19dcfdb"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.0/fleet-lsp-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "45e204090cf1eac7399eb58795db88391d7369cd2fa775dceb6a23ffc2052183"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.0/fleet-lsp-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "68c68ff86f21a561cc9d4863baa3d5bc6f194095e0cd4a40d873609f580df1f0"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.7.0/fleet-lsp-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85cb97d7c0efdecf142a408344cfd75fbbe91f258af6d1caa06ab1846b80e44e"
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
