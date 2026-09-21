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
  version "2.17.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.17.0/amont-agent-2.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "c1546215591413306bc68c4fc0f95cbb1c8179a0247c990fff986beda59870d2"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.17.0/amont-agent-2.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "4c0a1e56489269b4203d6a39c27fb956b678d6b5fcbbc5861429a633680c1f3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.17.0/amont-agent-2.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c8b87c71c5c3c0d9b0991661739dd1907ee56e289a32532442a724071570292"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.17.0/amont-agent-2.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "21768a4079d2f20e67a2eaa7e27ff2a4017063955c1dff5dd02a7966a6f4b620"
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
