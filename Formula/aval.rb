# Homebrew formula for aval.
#
# Prebuilt binaries rather than a source build, for the same reason amont's
# formula gives: the release workflow already produces and checksums them, and
# compiling a Rust toolchain to arrive at identical bytes helps nobody. The
# sha256 values below are the ones published in SHA256SUMS.
#
# Rewritten by scripts/bump-tap.py in the aval repository, which ASSERTS it
# found four url/sha pairs and a version line rather than hoping a regex
# matched. Keep that shape: four pairs, one `version`, no other release URL.
class Aval < Formula
  desc "The current architecture decision for a key, as a typed answer"
  homepage "https://github.com/fredericrous/aval"
  version "1.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.5.0/aval-1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "ded6b86a132863cd0a34ce0dbd83fe108bd5bffacac5520431921f17e3bb1953"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.5.0/aval-1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "295d4a9568e78b2e72c9e9075b9dacadae93457c6195ccf19b6c0f0287aad999"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.5.0/aval-1.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da88b04dcba352889e065a48598b6288d94ec17ad71443414f65b39331abc1e7"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.5.0/aval-1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c8bfcd7e1e26ee457a718124c0aa24aceeadba3641c5bbb0da369daad70d92c"
    end
  end

  def install
    bin.install "aval"
  end

  def caveats
    <<~EOS
      aval answers what is currently decided, from a corpus of architecture
      decision records. It gates nothing until you ask it to:

        aval keys                       the decision vocabulary
        aval resolve <key>              what is decided, with an exit code
        aval hook install               put the heads in front of an agent
        claude mcp add aval -- aval mcp the same answers as MCP tools
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand only this tool has.
    assert_match "resolve", shell_output("#{bin}/aval --help")
    assert_match version.to_s, shell_output("#{bin}/aval --version")
    # And it answers a real question against a real corpus, rather than only
    # proving the binary starts: a registry, one record, one resolved key.
    (testpath/".adr.yaml").write "dir: docs/adr\nscopes: []\nkeys:\n  a.b:\n"
    (testpath/"docs/adr").mkpath
    (testpath/"docs/adr/0001-one.md").write \
      "---\nid: ADR-0001\nstatus: accepted\ndecisions:\n" \
      "  - key: a.b\n    choice: One\n    first: true\n---\n# one\n"
    assert_match "active", shell_output("cd #{testpath} && #{bin}/aval resolve a.b")
  end
end
