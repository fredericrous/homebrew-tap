# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.3.0/fleet-lsp-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "015373a5b95ad41e74bf322cf597b7847421d0fec23c5f5297bb3fd4d9545c30"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.3.0/fleet-lsp-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "3fbd49608b1a71978786fc191af381f4fe3695eb1a7f9c0825b7d3d058f3b46c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.3.0/fleet-lsp-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a2eaacfb4294418b05987f7e6c1d3281b7fd87cbdcc0d71c98ac66f4c3f5719f"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.3.0/fleet-lsp-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e98cc859d4930da300e203d9d5e1361fd4ac4b3e38f77641a458a28a9b4f64b"
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
    # Outside a repository doctor refuses, with exit 1 and the reason.
    assert_match "not in a git repository", shell_output("#{bin}/fleet-lsp doctor", 1)
  end
end
