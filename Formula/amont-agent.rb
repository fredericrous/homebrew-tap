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
  version "2.11.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.11.0/amont-agent-2.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "f370f2324e8e2bba52bda7f774f5c321c495a4390f53a7fdb683189ae91bb129"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.11.0/amont-agent-2.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "a6b4b884cb4a2e75bd8a46f76bd0af9a70732e3202e413eafde262e73e9d73dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.11.0/amont-agent-2.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f87d2275169b81de8b1fd9f5a9faa2904c31b0b44a74fec859ae980968acac11"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.11.0/amont-agent-2.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f843e37955f11e9e4e75df5c3aec7f88d335a63b24a10acd19dbc230f95ba4d6"
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
