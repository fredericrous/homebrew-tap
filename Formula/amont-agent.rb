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
  version "2.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.8.0/amont-agent-2.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "f1173294d2be666bd6e24eb84a6e53ba7de600bbc0179153948af5411bf1bb54"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.8.0/amont-agent-2.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "7c337f9fa49aaec1b6e387502af868bb5477e33497ecb77265eaa7fbbb634d0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.8.0/amont-agent-2.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2418bf6b3828f1d025f6dfb258a54f1246a48a4d5a3a9a02445a34436d029428"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.8.0/amont-agent-2.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cae0ae52ab3b1335e1abe8199753c5ca11e36b2fddb8f37719a9fe552fd8c2c4"
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
