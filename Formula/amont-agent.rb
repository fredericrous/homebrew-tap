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
  version "2.21.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.21.0/amont-agent-2.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "67d59003a87a97a1d9f42b2da55e4b76893d9253e95f598a0327e9908cbbaa6b"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.21.0/amont-agent-2.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "5f3e7c63a2b5be3066c72aa4b1b6cf575e835f562e83519f59d3029d675cecf5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.21.0/amont-agent-2.21.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2b7d9c5aa2afee9b73a3188ba70d7dbf08e43f3b2463a9a984a94c085327a72"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.21.0/amont-agent-2.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1f087ff7ff065f171538add347907966f6bb60b59f14aadb2d3ebb88d763c76"
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
