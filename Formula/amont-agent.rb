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
  version "2.23.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.0/amont-agent-2.23.0-aarch64-apple-darwin.tar.gz"
      sha256 "c5f7d7f51416cb2797a72d050af33e62854fa16e869221bc4c6b277ba2c7a355"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.0/amont-agent-2.23.0-x86_64-apple-darwin.tar.gz"
      sha256 "1354794046cd600565bb7ef634d7ee5e3ef2a412104f76d0dcab59d7c05ce42a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.0/amont-agent-2.23.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "54c32bc09bb4f77370857857522bcc92caf121aa765e7e2bae2071a6fee9d909"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.23.0/amont-agent-2.23.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8f416d6e47913a5d795235a3f011026543602b0ec60241c1f2a19f525cdf092e"
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
