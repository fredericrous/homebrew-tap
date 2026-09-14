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
  version "1.3.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.3.2/aval-1.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "0368ceb6a2d5bfa8e3f4981c17d7070005618f9a6c4e7c039c7ec7eb0d5f2a8b"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.3.2/aval-1.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "9a2a9004152f8df521a271a324c86765df9c198096301e3e78be49a34a81f6d3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.3.2/aval-1.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6475b221de2c385d792f91e309a07d2114620d610b53e3ba9388da3db12bef75"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.3.2/aval-1.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a7fbe644f564d9fdeb8ef9972b54dca2d49d40801a56ce6e77d3099d0b20400b"
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
