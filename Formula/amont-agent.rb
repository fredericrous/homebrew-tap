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
  version "2.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.14.0/amont-agent-2.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "da3aa599b6c775b34618af29c65bd454963c20bbdde6deec31739fbc7a917339"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.14.0/amont-agent-2.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "0bb3e29ae56db751def53d0124768c650cf0090030bcabdbdc14d8857364be00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.14.0/amont-agent-2.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ace7313e4654ba96b659c3d77b13f080b63e00bc1237c87a3093f3d34258cb17"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.14.0/amont-agent-2.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8633a92bfa7083c62fa32ebba5d5939e0f7e495dc893601fb5364fd749899cec"
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
