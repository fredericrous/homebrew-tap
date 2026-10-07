# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.1.0/fleet-lsp-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "4dbbdd48f13df8dddcede6676d36287fc8d62dea107bf100ae730fd4f5ef7ce8"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.1.0/fleet-lsp-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "d3ac32ec997396a06d3c0b3a840ccece0c4fde6dbe257d657d96268e50ccfa74"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.1.0/fleet-lsp-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3b4e2554aebe70ad06bac46316a9e3dedc795bbd17bbde1bbec95c7dee66fc90"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.1.0/fleet-lsp-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d615072a45336f831466aac5b07a56df1426e30aea508315eecf457470bc412e"
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
