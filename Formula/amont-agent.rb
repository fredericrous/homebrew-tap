# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.33.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.0/amont-agent-2.33.0-aarch64-apple-darwin.tar.gz"
      sha256 "2f40acf3caf04e759f3b8f757cf84eb770fef6527396d0a9807c6e8902bb1ed3"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.0/amont-agent-2.33.0-x86_64-apple-darwin.tar.gz"
      sha256 "6d998d214e44a0de431ffe4b4b85a6ef338f35bc624ddb82320933162ae82301"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.0/amont-agent-2.33.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cabb533f006a30e3afa710baed3ccf3f85e51fe6ec3869690382b9c1e00e8eb6"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.0/amont-agent-2.33.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e8b6aca8f691d03716fe2b75df39b70e751689178360cd3a4958f7e0c891580"
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
