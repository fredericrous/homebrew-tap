# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.0/fleet-lsp-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "d01ae56c3ebaefa7ae975e290482d249b88ea4e5d8dd4b7b6d7bb8a5ecead004"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.0/fleet-lsp-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "510b63503786906e07aeb91a9793c997ea038c89b7de6739601c077f5d222f9b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.0/fleet-lsp-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "642bae906a11868032f8e9c8818dfbed7cd098b2a7404ef06e9434d46ba1355b"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.6.0/fleet-lsp-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "939034db5dc9727c3b7004b00875b03560f61a8e3a3b04122322e91ed6dc07eb"
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
