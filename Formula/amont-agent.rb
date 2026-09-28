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
  version "2.19.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.19.0/amont-agent-2.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "f980b1c088d2f55bd47924d3f9688c8502c2e4f27bc224a389b84867b00383c1"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.19.0/amont-agent-2.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "84ef4273396d549885bd94e2e4aeba486465574e2faadac36c6d70f4243546c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.19.0/amont-agent-2.19.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ac14cc8b2ff6345a34d9c944e01e718630b75c2ab3af9deda1c9fc4e6a72039"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.19.0/amont-agent-2.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "715500f395a08d4e8a4fdba647876e9750bf7ee04258105a03c132071becc147"
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
