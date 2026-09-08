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
  version "2.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.6.0/amont-agent-2.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "bb28b6cd0920e327df5460fa8b989bbba2d74c2d3b1503b0771ceda86674771b"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.6.0/amont-agent-2.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "cb0d221fde1d3c72b1a811d810d474b08364c4f515aae3fefd3d366c4a5d079d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.6.0/amont-agent-2.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4a298f142dc9fbcd51f8e622c6879ba5c1238596a1fd8b44153182174766390"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.6.0/amont-agent-2.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99b269236c4cc07d4dc4bc4aba9d2503a64686b29d749b91adefd7176bbb31e0"
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
