# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.27.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.27.1/amont-agent-2.27.1-aarch64-apple-darwin.tar.gz"
      sha256 "8bbf5d8eef821d2c68d7eb5c3c41c9fafc5c93956b2235fd2338519df6c901d2"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.27.1/amont-agent-2.27.1-x86_64-apple-darwin.tar.gz"
      sha256 "a829b92a0cba456a44f359cec0ed4886cb26c387fda090e650b00b65a68d1c3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.27.1/amont-agent-2.27.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f7a41ad2b39f6c58dc3ae39b79695d24a7ef1100f0769e206c6e4946ca8919f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.27.1/amont-agent-2.27.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9739bf3a8d222ae0d4605c72adbe3ea78b3ca3976354134ee7e82d760208331e"
    end
  end

  def install
    bin.install "amont-agent"
  end

  # Written by amont-agent's scripts/bump-tap.py from the released binary's
  # `amont-agent rules --json`; never edit by hand.
  def refusing_by_default
    %w[pipe-to-tail plan-review-panel]
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
