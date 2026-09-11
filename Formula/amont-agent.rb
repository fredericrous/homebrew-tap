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
  version "2.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.13.0/amont-agent-2.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "e7202ba9b19ec10e156f79934fa94f73fbae69726e6a2187a5f48235e8a666ca"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.13.0/amont-agent-2.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "002bd8e7baedc1c1780a6d1721d9bd4ecf5ec6f54495d1de499505e18bfe0dc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.13.0/amont-agent-2.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "32a7c770ea1af88c4e5b03157dc61a57b8e2d378c024a63113dd615263a2a40f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.13.0/amont-agent-2.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1dc00103a7dcb1cb0dabe494841b11a72a6e9b80ffb57f0c4c6974fa1cba0d9d"
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
