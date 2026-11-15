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
  version "4.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.2.0/greenpiste-4.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "400a2b1558e986620a8e5a4b04fded483584a6a09419ea454af5e2e53dded7af"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.2.0/greenpiste-4.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "51c12d45bef83ef8439d3402b7cf5dc2ead2d03591d5ebba8499b7fc838c2671"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v4.2.0/greenpiste-4.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3e39ce8d63f3896e682e9ffe0fdb70abf937bd70671ecb46bed9e551b63fdc32"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v4.2.0/greenpiste-4.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77ff7351707a8f679f26a5b5ccce87738113c9cc7111f3e4fe6aa4c6d49e354d"
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
