# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.4.0/fleet-lsp-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "f8ceb88bd9cccb0414956b32b607fa15771b79ca29c0148a7d64e28227ffe316"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.4.0/fleet-lsp-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "9d507a7b108a877deaf3f46159807645fc12f8b7ce80eb436f194e0e850874ec"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.4.0/fleet-lsp-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b57167ce05951c14094012423bc72ef1e5aac7f6cb9b2acf5e445400f1bd115"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.4.0/fleet-lsp-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d4d1fadd234c9a9090e8f10807307cbfd2dd0b146ec6e176aacb5e2d4819557"
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
