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
  version "1.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.8.0/aval-1.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "e92437df816f8b12e63a1f9d69cf86d8e6c5aa84f6f65735a6ce1fc376d4245a"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.8.0/aval-1.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "3f2e36c6f1a7e1978b7917a3661d0daadc9f2dfb1193fdb22feb938c5ff3f0d5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.8.0/aval-1.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "981bdde56e6f13ef19a3de0c4410ae25ea07400c87907ec3e26a4be81dc8920d"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.8.0/aval-1.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2281b8cd711a070600a9a1f73c231fd9fc30a384a4de8be345718886d68851a8"
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
