# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.29.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.29.0/amont-agent-2.29.0-aarch64-apple-darwin.tar.gz"
      sha256 "88b1692b1f97b5841fe0a724cd1bfe74ed466ee1b91752a65068e513eb979482"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.29.0/amont-agent-2.29.0-x86_64-apple-darwin.tar.gz"
      sha256 "c434a3398f174b001b2621c2c0690c995dc9a5a82656f21dce1ee916ac826ee0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.29.0/amont-agent-2.29.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2d0898d0746ec4cc9bae704c9ebf263e92bd646cd4bf2193db646d8aab45899c"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.29.0/amont-agent-2.29.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9cdda51a98f89879e1c190db6a5ea26a345f1853912d498eaf55a790b84f5579"
    end
  end

  def install
    bin.install "amont-agent"
  end

  # Written by amont-agent's scripts/bump-tap.py from the released binary's
  # `amont-agent rules --json`; never edit by hand.
  def refusing_by_default
    %w[pipe-to-tail plan-phases-open plan-review-panel]
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
