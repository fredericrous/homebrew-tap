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
  version "2.20.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.20.0/amont-agent-2.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "0d00b32047a121fb6e6e5e8fab5a44cdf7259dcb4137d321a3032d0e8f6bdc6f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.20.0/amont-agent-2.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "8db369d955b986e912c0a72293f4e7a00c3a3c61bdc7dbf7b90fe1d2cc08ad0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.20.0/amont-agent-2.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "430744f8e45f6907c4b5b64b09e18aeda9e409a430f100b40eb16a3f108ecf83"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.20.0/amont-agent-2.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "51dd0ac36e5ce63d7797c12f0ec28c7d09321e4ea3d39ca674f64fda2434aa77"
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
