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
  version "6.17.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.17.0/greenbelay-6.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "4bb6a6450705784c986cdeae3a8435806585fb11f1a01a5384837e3a8f1cebbf"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.17.0/greenbelay-6.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "b9a8e3eb6bfaa2611398642bf16fb156aa995d3649fce94bc89d071e26416d31"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.17.0/greenbelay-6.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cdb05611e542309ad2d7f3e8139542049338386e8ebeb0567cc1d61fed277afc"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.17.0/greenbelay-6.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ffa603c90ef39ce7c4fd93993dfb13c783674cef112bfe0a6ff95bbdd0568fa"
    end
  end

  def install
    bin.install "greenbelay"
  end

  def refusing_by_default
    %w[ask-unopened-page block-reinstate pipe-to-tail pkill-option-after-pattern plan-phases-open plan-review-panel suppressions-override workspace-root-write]
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
