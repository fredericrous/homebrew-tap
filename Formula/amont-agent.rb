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
  version "2.23.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.1/amont-agent-2.23.1-aarch64-apple-darwin.tar.gz"
      sha256 "22c6f772e593345ccd0a23eac9f9a5d6f7b3494993ea6a3e91e9dfa0ff2f4f08"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.1/amont-agent-2.23.1-x86_64-apple-darwin.tar.gz"
      sha256 "77b449a209c95d1e4dc3cb8b488b67830efb0d5d1a6a3fb9b8cd1c2c366a0e2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.1/amont-agent-2.23.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "22d5d51625c0102b4277b377809638b5f9bf9888c43e7b867f12e108ce929bd9"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.1/amont-agent-2.23.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "780de82cb6ad727a86dc58e135f53461facad5777a97716ae3c83661a50b43b1"
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
