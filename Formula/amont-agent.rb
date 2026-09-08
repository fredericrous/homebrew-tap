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
  version "2.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.5.0/amont-agent-2.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "c9a87aed8e4c11698a13a6f7b5d8bbd8620edd6c68570b640af95d8b8d2de0ef"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.5.0/amont-agent-2.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "5129dd46a65d0a35b9a07c373c180aec1884d5f3f4d9d77f8989962fd4a41387"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.5.0/amont-agent-2.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a63f67d911b97c1607b21deb7ced0a9fb7482e6f573e15dabc71f52d2adb7ddb"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.5.0/amont-agent-2.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7a42f5feeaf7eefdaef3dca3d9d4327554a9277eadc9b300e6046fd20be4144d"
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
