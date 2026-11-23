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
  version "6.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.8.0/greenbelay-6.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "48ec79e7258f2d4c0f86956c975152809ad6ad9dd98c09ef6735c851bf383fda"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.8.0/greenbelay-6.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "85d80f847da6702ef53413bf98f1f420f61caa3e60e2eb9dddd75ef892629fe6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.8.0/greenbelay-6.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "394977ce3145176990fc593d2e3f4bd929946c9adbc0b04081275bdb3949c0b4"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.8.0/greenbelay-6.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c50e9840a89dae5dbe760509ed218886a048bff03cc7bcd42887e58ccad33669"
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
