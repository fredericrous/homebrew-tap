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
  version "6.16.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.16.0/greenbelay-6.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "8955ac0ec978f2df28603bea1f50d6af5045a66f12beb0ebc0777c401f267a4c"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.16.0/greenbelay-6.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "1173b0cdb8bf789c71f59921a96bc67af043d2b1bf027d4084fa90d54102b56c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.16.0/greenbelay-6.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bba57427c6060aef4178b627cc60fe2bad56b0e2774ac7102af8cde69859ea1f"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.16.0/greenbelay-6.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fb7a0040ad0d38fbf0cec41f2f723fecf1ebf5af3dbc902757a9bf2fb97c067a"
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
