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
  version "1.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.7.0/aval-1.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "fb40b72d8c353be59426f05abb77abc7921c46917225609d8a3926730bf34640"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.7.0/aval-1.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "e68d48d12d677b948c5553dfe6bb495278b35f03c9f60b994e15e0b4d92dc772"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.7.0/aval-1.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a9c94d2149c1ce7054be034c0acb3dc5924ea31ad0eced59847aa1dd0ddad35b"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.7.0/aval-1.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0ae6435408f74932d9b96ba9cfba5cb11396824391a29d2d6b41c6f435fbeb7"
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
