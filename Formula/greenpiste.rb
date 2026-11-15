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
  version "5.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.0/greenpiste-5.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "ace3d759b9f7699f657b6a176b7439201bf75836fff2c08548edfe50dd20ad03"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.0/greenpiste-5.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "59eacd4c17aa60c9ca8ee97a18a6bc415870369135717e15fc9d71ba67f3f181"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.0/greenpiste-5.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "16f0505db9a23b9dbc0892154692fef93120f6877e42bc3e2cd0e0241b797c98"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.0/greenpiste-5.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6aa7b969be43ca59f345e78c3b1b5b81fcb1e2641e59eae36fa077479d0cb75"
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
