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
  version "6.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.5.0/greenbelay-6.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "b0b0b4523271783b8d2bc266233181c1d5a024c6f2fdcd0fb71c3a14862231eb"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.5.0/greenbelay-6.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "de10f1f50f7ae4464fd214732d78616ab26dc802b5068f76f4025800bd1c2323"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.5.0/greenbelay-6.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3962ea546ddce1d2120aaf08d24a4e307d0a0acb276bbb973a9d279e8fae2236"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.5.0/greenbelay-6.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd18ad90055dec8e24c917f7710f31159cae739e80b0d07d37d1a4f5b9237e32"
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
