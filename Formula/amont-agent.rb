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
  version "2.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.15.0/amont-agent-2.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "ac01a41c7b4d5ea980dbf293e5bea50100c22ae06ada45ba469a305c412e84d0"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.15.0/amont-agent-2.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "59e7a6da34ea79294c49140cbf841339cdfb3be746c983bd022f4b1d971705d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.15.0/amont-agent-2.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9457c01f11e8285a480309db4abc9e8b661f70fb4c812d69cad10558e6b1dc28"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.15.0/amont-agent-2.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9c8787f33b71b48b77ad94d275882c7d3b5f2e1489b16ac1b4bac75f0e0193c"
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
