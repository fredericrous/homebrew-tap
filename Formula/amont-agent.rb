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
  version "2.22.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.1/amont-agent-2.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "d4a5b4970865512586c298284f5b9f3dd8a84d34366e27505e1e71c012f6d463"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.1/amont-agent-2.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "520ff13893ed55fe55109e5c1d0a4e71775812ad29d3c47fd978beaf6d1301b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.1/amont-agent-2.22.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b5c4f80a139d695d36db252354cd81dccc7374c0ab9c5c4c57372a9c4ddf386"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.1/amont-agent-2.22.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3778573813d65af15e4eda36f1a190faa5bbdb0c66359f3876e44e2b512dcec"
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
