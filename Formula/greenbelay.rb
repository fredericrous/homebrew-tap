# Homebrew formula for greenbelay, formerly greenpiste (and amont-agent).
#
# The source of truth for Formula/greenbelay.rb in fredericrous/homebrew-tap:
# the release's `publish-tap` job copies this file there, rewrites its
# version, its four url/sha pairs and its list of rules that refuse by
# default from the release's own SHA256SUMS and binary
# (scripts/bump-tap.py), records the rename greenpiste -> greenbelay in the
# tap's formula_renames.json and removes Formula/greenpiste.rb, all in one
# tap commit made after the release assets exist. No old-name binary is
# installed (ADR-0071).
class Greenbelay < Formula
  desc "A guard for Claude Code's tool calls"
  homepage "https://github.com/greenharness/greenbelay"
  version "6.13.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.13.0/greenbelay-6.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "ace21e2dc8fd6d23a011c51f6fed65f4f4c4b86bb357bfb87dd43edb6faf00f9"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.13.0/greenbelay-6.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "c911e307b981f2bfe72bf1bc6abf4a4aec0bd053563d793f474e5482d9aea564"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.13.0/greenbelay-6.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0485bcd55853ca5d2fcf8de56873ad321a4c056aabc92b2086de599d151c6b5a"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.13.0/greenbelay-6.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9e6b4244a019b316c1067b2c10bc2f717f2d939cdd1833b8c44fb7d455f9a87d"
    end
  end

  def install
    bin.install "greenbelay"
  end

  def refusing_by_default
    %w[ask-unopened-page block-reinstate pipe-to-tail plan-phases-open plan-review-panel suppressions-override workspace-root-write]
  end

  def caveats
    <<~EOS
      greenpiste is now greenbelay, and no greenpiste or amont-agent binary
      is installed. Hook entries in ~/.claude/settings.json that call
      greenpiste fail until their command is renamed: replace the greenpiste
      path in each command with the greenbelay one (greenbelay install does not
      recognise greenpiste entries as its own, and would add a second handler
      beside each). When none is left, this prints nothing:

        grep -n greenpiste ~/.claude/settings.json

      Rules that refuse by default: #{refusing_by_default.join(", ")}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greenbelay --version")
    rules = shell_output("#{bin}/greenbelay rules --json")
    refusing_by_default.each { |id| assert_match id, rules }
  end
end
