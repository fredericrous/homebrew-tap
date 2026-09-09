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
  version "2.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.9.0/amont-agent-2.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "c65b9a730c0645ce3268d8935356261cc3fedfd78b305b648e3c01a6767b916c"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.9.0/amont-agent-2.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "d6636a0f63f00379a00b692ab7daf9072b87e4d2f7a8a757bcf208d356dfbcbd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.9.0/amont-agent-2.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ec9be7783862196ae6c13f9c1a7dff65bf39a2304b174ab1e1d13d672f0ed07f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.9.0/amont-agent-2.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "346e90fc53ef2f26af06f241bb40bf1404ec5b623af9a49792a891cfe8e64210"
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
