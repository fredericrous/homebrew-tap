# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "3.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.0.0/amont-agent-3.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "2c1384c8cd6684ee482c2fe7ed25743891fad4537f951618e494e6d5b82f447e"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.0.0/amont-agent-3.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "a78be3b8dd7e46d3004b12944ad65a25ce2186275a5c0bd49ab994789ff16e3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.0.0/amont-agent-3.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d6315c07827e6e8683945e26caf5bd69b992d6a0ad094ff1672489bbdc055f6f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.0.0/amont-agent-3.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ab6637f24d897cded4ca03cf4e35341827b392fef1b68660fb223e58a3eba0d"
    end
  end

  def install
    bin.install "amont-agent"
  end

  # Written by amont-agent's scripts/bump-tap.py from the released binary's
  # `amont-agent rules --json`; never edit by hand.
  def refusing_by_default
    %w[pipe-to-tail plan-phases-open plan-review-panel workspace-root-write]
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
