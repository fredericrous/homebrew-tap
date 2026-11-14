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
  version "4.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.1.0/greenpiste-4.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "ed279ed5f942352191daa1d87f143cb19cb7fa06516d392e8cd9620a19a62947"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.1.0/greenpiste-4.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "78203d0e83ce2f3be65d7cfc0a3870a1d4b31e011a077daffb165c2934f48d1e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.1.0/greenpiste-4.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82b89c0681284392d6db8d535f0017ee58b2c59b6e611a352b1871d53dec3cae"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.1.0/greenpiste-4.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c302168b77b0614c039dd8d8afe84e4814af910a2b034c4ed7bbf7d11d47448e"
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
