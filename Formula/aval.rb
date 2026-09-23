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
  version "1.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.7.1/aval-1.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "6ecc071bd4fa3aac67645b43b43f4f8243575f5e5b16fb3741e273d90e5b8d31"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.7.1/aval-1.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "9e33948ddf26b41340d09e14a66d9a866172318dbc2c94a5a3cc37a6d0f13edd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.7.1/aval-1.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f1a720c0441b0b546774251229292d00762a76556d529c9dff5c18716285d805"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.7.1/aval-1.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e79f651d840dab4c955de5ca5479133319fe9e931e8674fd48a883f740b31a1c"
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
