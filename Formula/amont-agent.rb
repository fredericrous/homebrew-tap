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
  version "2.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.10.0/amont-agent-2.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "0aaf5800e8d4451bb620c0e100ca2ae449751296b7529b61abf27c01c6fa119f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.10.0/amont-agent-2.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "a52da0cb801df610b473451e8f2c136563ffea4c76f9bd8c2b515799f501f932"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.10.0/amont-agent-2.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5cf42928842fb55a2a3e6184b192b9c8b5a98997c9b859465b5076d1a0f581f4"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.10.0/amont-agent-2.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f0e8e56aaaca2149b6236ed58e4500fba093e49f59111b1099cc0337e74f057"
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
