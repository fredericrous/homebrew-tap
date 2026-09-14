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
  version "1.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.3.1/aval-1.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "b871ffc808311297c55e4260f83d7f904e1e78a0c60165b82a653d0fa17177eb"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.3.1/aval-1.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "853a932c8ff286308573cf461a54972a2481f3160d778503f284b3073d8f4f6e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.3.1/aval-1.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "593db918ca87d75003f5c47ce76b48b1be42ce3dc13ff98d67ca22dc44713ed2"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.3.1/aval-1.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f0dca7a950143278c4074bdc7697472e3bb45ef11949a73aeba534a01c1b5b1"
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
