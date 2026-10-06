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
  version "2.26.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-aarch64-apple-darwin.tar.gz"
      sha256 "312e9bf498bb18e8292527863d2a139381181965d0833a64330382762c138d59"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-x86_64-apple-darwin.tar.gz"
      sha256 "068e5b97b6a70df797191ec7a4df8a3bef5f18d542b2a61de178d44e43cbc1c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "979491aa222e404a78b6c17b7481bd5c1db2eb08f9348c654c4bb3ac5c6c3781"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.26.0/amont-agent-2.26.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4d595645bc018729d99e646ae6cfda8d512e00b161f5fd1699e9acf7e6dea6b"
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
