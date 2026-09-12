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
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v0.6.0/aval-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "36b3c58288fad46ff81cb5cfe5fb4c967b94cd2c868f9216c692f84b97dba36f"
    else
      url "https://github.com/fredericrous/aval/releases/download/v0.6.0/aval-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "e58d2a6295f6c2ddfd30bb1bb3e02cffc61a3302c7a442f3cd11bf3109ca44d2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v0.6.0/aval-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1f457e3a31492addb4fad98754243a38f4f6faa3630a76c831cda60613b33eca"
    else
      url "https://github.com/fredericrous/aval/releases/download/v0.6.0/aval-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba6c3a0317f93d77b4d0a647bd40fcba68a47b144dbab7af80bf4e46ad2aa2ff"
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
