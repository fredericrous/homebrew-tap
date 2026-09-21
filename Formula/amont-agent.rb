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
  version "2.16.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.16.0/amont-agent-2.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "c2a6b193d9283bbdcb0dea8bc91ccd8a68fb5aa0d55ba716e6b2fefa9b1b9802"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.16.0/amont-agent-2.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "b41ffe4a81c8ee11b9ef347557b6904eedf086cd738c3a13a0e73dc84503bcc9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.16.0/amont-agent-2.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5bfcdb7755ba6ccd50b96896b3f7fc4fbd3404ad340941f66b60f3472e157a51"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.16.0/amont-agent-2.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5447bcd1904295645a093c2e5d13dc6d569ef88ed6d89f57cdb3f646c7bc36a"
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
