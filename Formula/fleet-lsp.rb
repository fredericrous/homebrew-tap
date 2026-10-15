# Homebrew formula for fleet-lsp — the seed for fredericrous/homebrew-tap.
#
# Prebuilt binaries, checksummed by the release workflow. Rewritten on every
# release by scripts/bump-tap.py in the fleet-lsp repository, which ASSERTS it
# found four url/sha pairs and one version line. Keep that shape.
class FleetLsp < Formula
  desc "Pinned, ready language servers for Claude Code's LSP tool"
  homepage "https://github.com/fredericrous/fleet-lsp"
  version "0.5.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.3/fleet-lsp-0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "9bac5d179e2aee9fedb74e7c099e9a67ae5336b5d843c8a7a06fc6e229b95d44"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.3/fleet-lsp-0.5.3-x86_64-apple-darwin.tar.gz"
      sha256 "780d671cc47581094f39ca9f3c791c07cadb322c9f3678d11eead907c62ac224"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.3/fleet-lsp-0.5.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57266c89fa6aa593cbdcda682434cf4ca74b4f36adc2bd40f0bcda511b98930f"
    else
      url "https://github.com/fredericrous/fleet-lsp/releases/download/v0.5.3/fleet-lsp-0.5.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "243dc41bd494a30bfaebbdb4e47fc33ef303bb391ac6b36eae5b642d5e49532f"
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
