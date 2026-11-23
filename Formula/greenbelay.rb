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
  version "6.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.10.0/greenbelay-6.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "caffb388276ebc92f9b84e3b38dd613056af6b18338a27b6adafbbd248d1dd7b"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.10.0/greenbelay-6.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "ff7db2f00e1f6d8ec2b6989316f4557319ef2cb1cf065287478cde37d3a9070b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.10.0/greenbelay-6.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4b21e9fa97426eb390f616d8d5cc61103a160bede4528a3858bb5f2a3be1e20"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.10.0/greenbelay-6.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c9b8ee6cd79adff9e782fabcf0752511218527518bd1bd1b6c3415c3b8d3a86"
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
