# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.31.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.31.0/amont-agent-2.31.0-aarch64-apple-darwin.tar.gz"
      sha256 "bcac2a9e4f5052a7127c0b11716ff1dca69693e5156588cdb14a3b2b14ed01c8"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.31.0/amont-agent-2.31.0-x86_64-apple-darwin.tar.gz"
      sha256 "ff76f2cfd1c90fcee038434a6185dd3ca3eed8cd2099c4a020488f2cedd64127"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.31.0/amont-agent-2.31.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f42d68b3b4bf5aa6977f7b6cacdfe39497137a538fe00d30969b05fe27e39df3"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.31.0/amont-agent-2.31.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1e9c567e0c3e92b6aa24976a745762647bff7b32fd71f63447908d53ff19fd5a"
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
