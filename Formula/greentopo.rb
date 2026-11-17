# Homebrew formula for greentopo (was aval, ADR-0072).
#
# Prebuilt binaries rather than a source build, for the same reason amont's
# formula gives: the release workflow already produces and checksums them, and
# compiling a Rust toolchain to arrive at identical bytes helps nobody. The
# sha256 values below are the ones published in SHA256SUMS.
#
# Rewritten by scripts/bump-tap.py in the greentopo repository, which ASSERTS it
# found four url/sha pairs and a version line rather than hoping a regex
# matched. Keep that shape: four pairs, one `version`, no other release URL.
class Greentopo < Formula
  desc "The current architecture decision for a key, as a typed answer"
  homepage "https://github.com/greenharness/greentopo"
  version "2.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greentopo/releases/download/v2.0.0/greentopo-2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "30a3fae1eb59a5e5e94271950975bcabd4486d1585e5dd4621b24c6195e54013"
    else
      url "https://github.com/greenharness/greentopo/releases/download/v2.0.0/greentopo-2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "912d9de53f9ce10c7342854e18fedb12d42419273052c81eef982191a6c67557"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greentopo/releases/download/v2.0.0/greentopo-2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6c62826f9f0a1c7db6b4f30c73cf6198cdca609b0323ae04d446aaaf2d7d5129"
    else
      url "https://github.com/greenharness/greentopo/releases/download/v2.0.0/greentopo-2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1c39c749d46fd21e3c12c4aacb3153f59074eb701b3bdab370181bce25b2501"
    end
  end

  def install
    bin.install "greentopo"
  end

  def caveats
    <<~EOS
      greentopo answers what is currently decided, from a corpus of
      architecture decision records. It gates nothing until you ask it to:

        greentopo keys                  the decision vocabulary
        greentopo resolve <key>         what is decided, with an exit code
        greentopo hook install          put the heads in front of an agent
        greentopo mcp install --write   the same answers as MCP tools
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand only this tool has.
    assert_match "resolve", shell_output("#{bin}/greentopo --help")
    assert_match version.to_s, shell_output("#{bin}/greentopo --version")
    # And it answers a real question against a real corpus, rather than only
    # proving the binary starts: a registry, one record, one resolved key.
    (testpath/".adr.yaml").write "dir: docs/adr\nscopes: []\nkeys:\n  a.b:\n"
    (testpath/"docs/adr").mkpath
    (testpath/"docs/adr/0001-one.md").write \
      "---\nid: ADR-0001\nstatus: accepted\ndecisions:\n" \
      "  - key: a.b\n    choice: One\n    first: true\n---\n# one\n"
    assert_match "active", shell_output("cd #{testpath} && #{bin}/greentopo resolve a.b")
  end
end
