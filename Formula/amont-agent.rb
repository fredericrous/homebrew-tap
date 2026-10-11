# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.35.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.35.0/amont-agent-2.35.0-aarch64-apple-darwin.tar.gz"
      sha256 "25c80a05c7630782e6508c0fd7c946a84e15b364120684e3d47813ae48e6c560"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.35.0/amont-agent-2.35.0-x86_64-apple-darwin.tar.gz"
      sha256 "04c6969026dbbfef908682b3c02d9ce9747da107a873ee7830dd07903be98b96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.35.0/amont-agent-2.35.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2afa28660f66485988d636670f1476d63f50f02e99b535cebe81a9d579c19ea0"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.35.0/amont-agent-2.35.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c7c938928f193b4f2b6f26f3c9cb9d3a3ff6b2dff222e8504f761eb5c98b612"
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
