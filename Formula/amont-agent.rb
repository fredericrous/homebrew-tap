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
  version "2.0.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.2/amont-agent-2.0.2-aarch64-apple-darwin.tar.gz"
      sha256 "2ac39baf703e7c7848c2b8d320a48523f39200cf675c3a5ac276f37f3fe85808"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.2/amont-agent-2.0.2-x86_64-apple-darwin.tar.gz"
      sha256 "da0601adc601c58effb6f1ab15fedc785bf526d0a4038de36ed8710feccb0a59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.2/amont-agent-2.0.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b466725c310190164bab9e3759cc95c99bc72a0b3aa6c2d70032b409f98c5996"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.2/amont-agent-2.0.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fc4c8aa931948ce6f52f6a3e1dc9e8b31e00cc5b2d18604870370aca7aa13c9"
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

      Every rule but pipe-to-tail ships as `observe`, so nothing is refused
      until you have seen what it would have caught:  amont-agent status
    EOS
  end

  test do
    assert_match "pipe-to-tail", shell_output("#{bin}/amont-agent rules")
  end
end
