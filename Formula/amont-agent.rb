# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "3.11.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.11.1/amont-agent-3.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "25b5faa36bf22aa984a2b2d0e86bbaa1ad562acbf4d32bee1c2ec8a48bacbb46"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.11.1/amont-agent-3.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "ef8750656b9fa82cacf58bb1ab0f6e4cc351361a43b08e4b97310020f0c5a064"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.11.1/amont-agent-3.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7ffb02eedf9de8482b70666ba9a5ff87945fb16942df83bf42c6b057780ca0fb"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.11.1/amont-agent-3.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45860214ffd18594cb1624eda157bb0010960b7b213ac993160035c68a68e67c"
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
