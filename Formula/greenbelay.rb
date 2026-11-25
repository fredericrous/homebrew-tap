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
  version "6.15.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.15.0/greenbelay-6.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "2bd1e00a6b0739c211a9fd20b2e373e4272892e48d195f20b943c74f2f5b9706"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.15.0/greenbelay-6.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "f0a06f2a3f756df0dc7135940ec54a4ae830f7c0912d570e5b4db5f07849e860"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenbelay/releases/download/v6.15.0/greenbelay-6.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bf1816a5f74ab27aa38e6176846f7a9a3627f8ba64fd1f45e46f136f91dc19f"
    else
      url "https://github.com/greenharness/greenbelay/releases/download/v6.15.0/greenbelay-6.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "260df7eaf1dbb04c94c4a627beef8072c459b0f0e636365ce3799bc1b51db12b"
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
