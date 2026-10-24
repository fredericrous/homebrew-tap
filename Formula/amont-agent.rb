# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "3.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.2.0/amont-agent-3.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "38ab8cbe5b37ce3053b92f9bc7abb97c1dabe4a9098d99d422130b8064418e9f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.2.0/amont-agent-3.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "ea435548d4f54149ef867092879ac9ffa2de2aded8d10498cffb28525567f987"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.2.0/amont-agent-3.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2b7ee2cfc4b2847c3ef6c3688617c5aa29c9cd21ddc3a82aad5f3e562c766a43"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.2.0/amont-agent-3.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f14ce1f63e3a504c2210aa2b0ff38beb9c850c963b4b1e45d08dfd126c30764"
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
