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
  version "6.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.11.0/greenbelay-6.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "49795ae110c2d650a0fc562f0dd740a1b669c63a4e90658f637e8d9aa4626100"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.11.0/greenbelay-6.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "50fbbee96ef5a9c27e10dcf9e003fffe936e531776bc682cb1b750ec9016b963"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.11.0/greenbelay-6.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "25a8521e6c725a4604b46c99991fb915c93c167af9abbbb0d3ac6e02d12e4b36"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.11.0/greenbelay-6.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c547bcfc32c0f722312fb4d1cb06c18e415f1fcce4ecc1ffb4c6513f6819db4f"
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
