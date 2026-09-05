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
  version "2.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.1/amont-agent-2.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "78bbade98c7fe9b69fc9bd8ad0712fdf45e6ca190017e17b5dc2c65ebd38ae42"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.1/amont-agent-2.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "8a0a4b30a6090c1d7550e21e537284f653f66322aaea5ce0fc63e373b36f5358"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.1/amont-agent-2.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "46533be6004c7f3cf1a8a9cc15ec076cebd667480e3f5e6eba15c6af825603c1"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.1/amont-agent-2.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "398d5a8c4fb67d85bc9779dfdd56c5eec734ac6ba70db0d0362e15f77a4d5b43"
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
