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
  version "6.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.3.0/greenbelay-6.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "b327b7f48b8ac4997901ecb94efd7a8348755b032ede19842253660fbfeeb60f"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.3.0/greenbelay-6.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "5f06a79a1527f94af674292fc1ef029f50cffe3000548801c178ce5e345824af"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.3.0/greenbelay-6.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "804cef3098922bbf395b353fbf1f2d84a079fc10d16244cdba4ca564597727ee"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.3.0/greenbelay-6.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ceaef326efd41e45da05dffeb4bcd5ce7db13fb8e9f595d314a85fe7f98761d8"
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
