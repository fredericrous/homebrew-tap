# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.1/fleet-lsp-0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "e903400aae590e217967f2cc0863b3fad713e946d88ece9d6bb3ea7e66ee1e92"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.1/fleet-lsp-0.5.1-x86_64-apple-darwin.tar.gz"
      sha256 "36dc8c264532e3f9fb42f54adf1950b00651b7573df409d7038baa6b10e66b00"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.1/fleet-lsp-0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe4a30c289c9de84b27c69188b409138b6e8643bb3a0c5d4a580c6566a880155"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.1/fleet-lsp-0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "803ba394f9add057d31e8f4347d525ce28b8f5d79198e8c3ab2fa22c01734cc6"
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
