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
  version "2.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.0/amont-agent-2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "bd38a80d6114fa10d7a20cf636cd22a3a677130ef5dce719406e2ab4ee40569f"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.0/amont-agent-2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "a405810dc67dc19785c65f85ed8c20650903be094d38ed136daca28f381b3c5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.0/amont-agent-2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0b359609557ae399bafea99a0d90d14b92ba38cff2631bb4d84f4d1222caa8ca"
    end
    on_intel do
      url "https://github.com/fredericrous/amont-agent/releases/download/v2.0.0/amont-agent-2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "73622aee3bcce4e3be87441a121bd9cff6f74c7483d6b1a022cacf537a23a758"
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
