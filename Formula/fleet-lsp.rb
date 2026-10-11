# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.2/fleet-lsp-0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "4b92b6375bc4531b1e545d2a04bd31e9f850102d7179c0e27c68a619017df533"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.2/fleet-lsp-0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "760e7e9ca85bce9836b55bd657fe784bc3235ff672b773c9f4914590107cd5c6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.2/fleet-lsp-0.5.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f026a4a82198a209de4fb42147974d3f5971f017b12c32e3f97da4424d000971"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.2/fleet-lsp-0.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "475fb63ae9c504ace3bf058daaeb4ace3dfc7abde327c91057d893dbad6afff0"
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
