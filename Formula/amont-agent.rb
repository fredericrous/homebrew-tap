# The initial formula for fredericrous/homebrew-tap.
#
# Copy this to `Formula/amont-agent.rb` in the tap ONCE, then never edit it by
# hand: `scripts/bump-tap.py` rewrites the version, the four url/sha pairs and
# the `%w[...]` line of `refusing_by_default` on every release, and it asserts
# on exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
#
# The placeholder sha256s are zeros. The first release's `publish-tap` job
# replaces them with the real ones; brew would refuse this file as-is, which
# is the correct behaviour for a formula that names no real bytes yet.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.26.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-aarch64-apple-darwin.tar.gz"
      sha256 "312e9bf498bb18e8292527863d2a139381181965d0833a64330382762c138d59"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-x86_64-apple-darwin.tar.gz"
      sha256 "068e5b97b6a70df797191ec7a4df8a3bef5f18d542b2a61de178d44e43cbc1c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "979491aa222e404a78b6c17b7481bd5c1db2eb08f9348c654c4bb3ac5c6c3781"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4d595645bc018729d99e646ae6cfda8d512e00b161f5fd1699e9acf7e6dea6b"
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
