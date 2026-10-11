# The amont-agent formula. Do not edit it by hand: on every release,
# amont-agent's `scripts/bump-tap.py` rewrites the version, the four url/sha
# pairs and the `%w[...]` line of `refusing_by_default`, and it asserts on
# exactly this shape — four `url` lines each followed by a `sha256`, one
# `version` line, and one `%w[...]` line inside `def refusing_by_default`.
# Change the shape here and the script will refuse rather than guess.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.33.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.1/amont-agent-2.33.1-aarch64-apple-darwin.tar.gz"
      sha256 "d499bb174f0facf5392a5085c0d0b724ab41518df1eb3b833e373e702b838cfd"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.1/amont-agent-2.33.1-x86_64-apple-darwin.tar.gz"
      sha256 "0c500739dc17251610d498a3fccac9548013e84a7ef7be298df629c298d01ea1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.1/amont-agent-2.33.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ab596218bdedec84e37b50e185c04f87b7c1c82eb04cd53bcf95e7eeb35ce4dd"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.33.1/amont-agent-2.33.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "823e8c866f34c5a2c458ac435dcea91ce7f381ae8f54ab6e751941d46173d17a"
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
