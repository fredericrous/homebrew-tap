# Homebrew formula for greenpiste, formerly amont-agent.
#
# The source of truth for Formula/greenpiste.rb in fredericrous/homebrew-tap:
# the release's `publish-tap` job copies this file there, rewrites its
# version, its four url/sha pairs and its list of rules that refuse by
# default from the release's own SHA256SUMS and binary
# (scripts/bump-tap.py), records the rename amont-agent -> greenpiste in the
# tap's formula_renames.json and removes Formula/amont-agent.rb, all in one
# tap commit made after the release assets exist.
class Greenpiste < Formula
  desc "A guard for Claude Code's tool calls"
  homepage "https://github.com/greenharness/greenpiste"
  version "4.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.3.0/greenpiste-4.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "ed15c7701d3a7c954a65622e11fc033a639fd3db2b8e59f06731814333d3fe27"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.3.0/greenpiste-4.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "80726f7f43db88b4274c93d81c1b0d00dc5cda8590e56e13b92106103aa44c5e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.3.0/greenpiste-4.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1cb873f1b0c9ed180c34118ec79bfef0022aea4f93c46b696c07bcd8983c4dd6"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.3.0/greenpiste-4.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7199de48e11be9d55c66f7106fbf0f85e9b54c08bde6aa595f3d7b30c4b25908"
    end
  end

  def install
    # The old name as a COPY, so hook entries baked to
    # #{HOMEBREW_PREFIX}/bin/amont-agent keep running this build. A copy,
    # never a link.
    cp "greenpiste", "amont-agent"
    bin.install "greenpiste", "amont-agent"
  end

  def refusing_by_default
    %w[ask-unopened-page block-reinstate pipe-to-tail plan-phases-open plan-review-panel suppressions-override workspace-root-write]
  end

  def caveats
    <<~EOS
      amont-agent is now greenpiste. `amont-agent` is installed too, as a
      copy of greenpiste, so hook entries baked to the old name keep running
      this build. Rewrite them with:

        greenpiste install --write

      Rules that refuse by default: #{refusing_by_default.join(", ")}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greenpiste --version")
    assert_match version.to_s, shell_output("#{bin}/amont-agent --version")
    rules = shell_output("#{bin}/greenpiste rules --json")
    refusing_by_default.each { |id| assert_match id, rules }
  end
end
