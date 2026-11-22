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
  version "6.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.7.0/greenbelay-6.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "509175288fd2dede18ad250b2df55907468bb81a277c46dac1cf37b9a3102aa7"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.7.0/greenbelay-6.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "bb16f53bd51adb00f01c6a62a67a2a47bb74f80f4701f986af1ae01309f09397"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.7.0/greenbelay-6.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "70cf6e0310a7999cf3a9a709b9b8dfed97fa7dfab833e7bd64dae1dde1d3b840"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.7.0/greenbelay-6.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb45373b49f1d9ae22ca8a953ab2d6b3f9e4a96fd3ed4de4c4d51275f7bffb67"
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
