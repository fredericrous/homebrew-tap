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
  version "2.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.3.0/amont-agent-2.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "ef2af47f7901d42c5ab95fab5b526b0d36bfe3fb16e0a704186e685d10cbe04f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.3.0/amont-agent-2.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "814c9c1fa4ff01c9f1644f17034627925c0f6f889d3e2169b75c4db4cf25fd69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.3.0/amont-agent-2.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe1b45a9eafef3b3e7359a2aebbed6a8211c4e91fe646a4f533942494d8dc922"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.3.0/amont-agent-2.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61f6d1376b04e774effe650c13478578098e29d615f212c024834d7085828051"
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
