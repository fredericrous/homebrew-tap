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
  version "5.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.1/greenpiste-5.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "ea9b25696397012baeb91909a6545071008915a02887491b1936bfab662dc2b7"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.1/greenpiste-5.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "419e0b19092e37d112054210266f1271db2df3a9dc6eebef549c314efee54c9a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.1/greenpiste-5.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a6bc2cf281ef4fcd9b8101aa90459fa127e4665d32d55e48d9c7d7094cc507ce"
    else
      url "https://github.com/greenharness/greenpiste/releases/download/v5.0.1/greenpiste-5.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a45b4ba358c563da165d3e122829d902fc0b5e5bb126fe1797e767707f4f209"
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
