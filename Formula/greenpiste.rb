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
  version "4.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.0.1/greenpiste-4.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "ce92ac143f8b78baf978b304c5d87a859b8909894d6055e5b4e723ea77d66447"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.0.1/greenpiste-4.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "2b5816c27cf649cf20cc88a361328dc837adfff5cc668d62c00e746881e4bc15"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.0.1/greenpiste-4.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24a6d626640407a351ac7feb35d8a67d4d22ee201800a24414f5cf1306c7427d"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.0.1/greenpiste-4.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29ef9095edb8dc864e7abe04e85546102bfdf3bbcea5ebbba9e0109bf5524466"
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
