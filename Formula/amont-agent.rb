# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/greenharness/greenpiste"
  version "3.35.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/greenharness/greenpiste/releases/download/v3.35.0/amont-agent-3.35.0-aarch64-apple-darwin.tar.gz"
      sha256 "0649c0c402e33681d9f4c75dbad9d0a38f55b260f0a63bd9ac27a254b0bc914e"
    end
    on_intel do
      url "https://github.com/greenharness/greenpiste/releases/download/v3.35.0/amont-agent-3.35.0-x86_64-apple-darwin.tar.gz"
      sha256 "b51889566533620831e1c7ba0ab005bf1610cefad948c89979684bfe8a664a33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/greenharness/greenpiste/releases/download/v3.35.0/amont-agent-3.35.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1c48956d3bcbb760beafa8f347c66e6a65c180687c9d20fbf0057708730d4cff"
    end
    on_intel do
      url "https://github.com/greenharness/greenpiste/releases/download/v3.35.0/amont-agent-3.35.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ccd3ea5e385b671f519001f02a4729ab7e57f511a32dc82870b2a2ee5668134"
    end
  end

  def install
    bin.install "amont-agent"
  end

  # Written by amont-agent's scripts/bump-tap.py from the released binary's
  # `amont-agent rules --json`; never edit by hand.
  def refusing_by_default
    %w[ask-unopened-page block-reinstate pipe-to-tail plan-phases-open plan-review-panel suppressions-override workspace-root-write]
  end

  def caveats
    <<~EOS
      The guard is installed but not wired in. To add it to Claude Code:

        amont-agent install          # prints the settings block, writes nothing
        amont-agent install --write  # merges it into ~/.claude/settings.json
        amont-agent doctor           # is it installed, runnable, and firing?

      These rules refuse a command by default:
      #{refusing_by_default.map { |r| "  #{r}" }.join("\n")}
      Every other rule advises or observes; each one's stance is one line away:
        amont-agent status
    EOS
  end

  test do
    # Up to 2.26.0, `rules` ignores `--json` (it prints the text table,
    # exit 0), so the check against the caveat's list runs from 2.27.0, the
    # first release that has it.
    if version >= Version.new("2.27.0")
      require "json"
      ohai "checking refusing_by_default against `amont-agent rules --json`"
      rules = JSON.parse(shell_output("#{bin}/amont-agent rules --json"))
      shipped = rules.select { |r| r["kind"] == "rule" && r["default_stance"] == "deny" }
      assert_equal refusing_by_default.sort, shipped.map { |r| r["id"] }.sort
    else
      ohai "#{version} predates `rules --json`: checking the text table"
      assert_match "pipe-to-tail", shell_output("#{bin}/amont-agent rules")
    end
  end
end
