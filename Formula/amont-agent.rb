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
  version "2.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.4.0/amont-agent-2.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "4c7caffaff8880d0936e018a974f4980af6cc896ca9524c12d3eb55c6cbf3f10"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.4.0/amont-agent-2.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "babbb3d9a5089e0381137eabece2c25766f51f1dade9d65ca7c1464ec5537833"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.4.0/amont-agent-2.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "76dfcc96d341b3fd71b1c6f02938ccd7b90dd03ac39099881a038e3954be3665"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.4.0/amont-agent-2.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cfa0800f6bc4f94e719592316c5bbc3f662b146a85991cacf883cf8fd8eeb84b"
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
