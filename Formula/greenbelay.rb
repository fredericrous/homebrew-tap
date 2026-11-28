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
  version "6.18.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.3/greenbelay-6.18.3-aarch64-apple-darwin.tar.gz"
      sha256 "c1db6da0401a0ecdeb2e3d7d6eec10644b09245f432b8c24ee604a2fcc1dd2fd"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.3/greenbelay-6.18.3-x86_64-apple-darwin.tar.gz"
      sha256 "e0819a0048c02e3dd568eb68e94d4f0ace449d641b0ab5c9bf0339869ede24b9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.3/greenbelay-6.18.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d4376f254509800402694a1f3d5b3ae9d154cf31ccaab32e9879e24801ade5f"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.18.3/greenbelay-6.18.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "18881f5f3826041c18cac85febb1461c54cb5212c283358955f6fa46294b0ba5"
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
