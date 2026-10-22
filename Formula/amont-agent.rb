# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "3.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.1.0/amont-agent-3.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "f4c764bea21e367a9c2215c5ea25d4a76da6b4b4c53265856fe4d0904a907ae9"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.1.0/amont-agent-3.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "35b781fdf6e36b0cb3ffed59c9f2426a79ae4992988286e3c1cf3c1d79a2fd95"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.1.0/amont-agent-3.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "75a199ee67e77dfc01c8fe7cede399f632d0a577a63fcac8089797118abd418e"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v3.1.0/amont-agent-3.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89596e37dc13c145a852b12f647752b8ddd672f43e85b038ec87020fd3989aab"
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
