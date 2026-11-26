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
  version "6.18.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.0/greenbelay-6.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "441d2340d4cdc1595bae4cd6903bfb803042d4de302a15733a81e0a8c9d15fb6"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.0/greenbelay-6.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "f2978cae54058ec0570e8c68d158e4f3d7665a932996381daf1bd5f0f52a11e9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.0/greenbelay-6.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0c499b42ce90e63e88404a9a78f712d2c523f9e70e9c76e0cfd8fef90fac4bca"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.0/greenbelay-6.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfe8c3b588ab2c7fe40717be13da456a6e993aac0c5c2f4dbb837b8e12f1fe5f"
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
