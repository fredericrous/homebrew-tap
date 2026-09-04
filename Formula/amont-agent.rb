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
  version "2.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.0/amont-agent-2.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "5b64edfe537bb8e35e9662e10df986346b03ff26ccd234ffe0d0037d494630af"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.0/amont-agent-2.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "00e42cfc1f68c1a1fd698026e32062ab829f7e54f84fca0fa5a8ce5c8504c3aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.0/amont-agent-2.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "68c3d455cc93938774ec22dc72063796d28d8d4d6825ad1ac39c6d2bc50fffa8"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.1.0/amont-agent-2.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "95fd16e7adc580dbc2961937b6a8f4390d1e75328cf6275704350e0128039a38"
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
