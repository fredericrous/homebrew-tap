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
  version "6.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.4.1/greenbelay-6.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "400a05a844e042f2ebf90857431fcf091a131849a9217749f431092275e40f57"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.4.1/greenbelay-6.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "2cc4c9d7148e37c1547aee7cb00401a44e8c0956b2ea6d254fd56b514a4cdb21"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.4.1/greenbelay-6.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b9cc39bd1ea02e0619fb99914297c93323e6a1171de01c926e63e2e1cdb4018"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.4.1/greenbelay-6.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "06947c08bd0f652949b3e4046d90f82084b594b366c11e85f1db50179099f9a3"
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
