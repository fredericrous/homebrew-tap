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
  version "6.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.0.0/greenbelay-6.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "e3b881157531c55d4c0e4c315afd4f7162ca083afc513f87674d6ad49c5c76bd"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.0.0/greenbelay-6.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "494b62890bfba6d5ff8e2f3be5b627805509af130ddfeb3f07c897e7bf3deb48"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.0.0/greenbelay-6.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8517e6b7aef9b798b0b2b74e5847ed8a5099fa45a613c8c9324dd6642a26da8e"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.0.0/greenbelay-6.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9139f56c4401273d982815ef66b909e60cfb85892230816781a45f2be2114dda"
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
