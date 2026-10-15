# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.42.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.42.0/amont-agent-2.42.0-aarch64-apple-darwin.tar.gz"
      sha256 "09dc15e961cd558070ef17a7457c5f9f954ef9bab6a2bc492b32fdd61a82b0d1"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.42.0/amont-agent-2.42.0-x86_64-apple-darwin.tar.gz"
      sha256 "f48019df85bb57ed8b1ba93c8bb20f0a3c31e0c84318607aeeddaa156ceaa26a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.42.0/amont-agent-2.42.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "048986f4700221f6f7ac9c971374fd8aece6f264585b85c3db93e1c080f5a458"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.42.0/amont-agent-2.42.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3aecda3c524abf62a0ddd588c954bda43f3b7c788d73605a5d034384b664ea7"
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
