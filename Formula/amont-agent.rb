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
  version "2.22.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.0/amont-agent-2.22.0-aarch64-apple-darwin.tar.gz"
      sha256 "8cfaa80096a7bb2439d27d3eb52d4418ceab0726c1d0ba71faec1a4731f92f7c"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.0/amont-agent-2.22.0-x86_64-apple-darwin.tar.gz"
      sha256 "3809d9b60194acd93298e0420d675d7d09e08e4fceba742a8e4097e037872f9e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.0/amont-agent-2.22.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d74cb61621e88198604e600d3a94806c26ec1390b477a649b35592bfd17384e3"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.22.0/amont-agent-2.22.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66c62ab87c31ec63a62848feb7b5eb5ad25a26703427e2aed7365c37d9f891c7"
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
