# The initial formula for fredericrous/homebrew-tap.
#
# Copy this to `Formula/amont-agent.rb` in the tap ONCE, then never edit it by
# hand: `scripts/bump-tap.py` rewrites the version and the four url/sha pairs
# on every release, and it asserts on exactly this shape — four `url` lines
# each followed by a `sha256`, and one `version` line. Change the shape here
# and the script will refuse rather than guess.
#
# The placeholder sha256s are zeros. The first release's `publish-tap` job
# replaces them with the real ones; brew would refuse this file as-is, which
# is the correct behaviour for a formula that names no real bytes yet.
class AmontAgent < Formula
  desc "Guard that inspects a shell command before Claude Code runs it"
  homepage "https://github.com/fredericrous/amont-agent"
  version "2.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.12.0/amont-agent-2.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "5fea28b179a54648f8fe8ff7b06281c306c6bd3e27fb24dbe4b4ec055fe37907"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.12.0/amont-agent-2.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "f4b02a6428b6ed1bc606e9c87a7bdf3864f7197a5f72446843de5548af980d3b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.12.0/amont-agent-2.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "659947e9f514a837f8936fc2e09ba365793e8b9b48e33399e72b496c51fdf002"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.12.0/amont-agent-2.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c2920a7990d41745fff5e09496527a454967a568f5d34c82904958fbf88d0c6"
    end
  end

  def install
    bin.install "amont-agent"
  end

  def caveats
    <<~EOS
      The guard is installed but not wired in. To add it to Claude Code:

        amont-agent install          # prints the settings block, writes nothing
        amont-agent install --write  # merges it into ~/.claude/settings.json
        amont-agent doctor           # is it installed, runnable, and firing?

      Only pipe-to-tail refuses a command; every other rule advises or
      observes, and its stance and measured rate are one line away:
        amont-agent status
    EOS
  end

  test do
    assert_match "pipe-to-tail", shell_output("#{bin}/amont-agent rules")
  end
end
