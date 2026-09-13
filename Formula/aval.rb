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
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.0.0/aval-1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "a96695e2416145fac143e904bcdc226bc26610e8f65e09463d3d5e4332868c2f"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.0.0/aval-1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "743477672269eb2f970d3da06b2695344774912d2776c0de33e3961090ca5942"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/aval/releases/download/v1.0.0/aval-1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8a435c352c3f5c073c8c162211c958ee8652c77aa6399771aa3c92908ac30c48"
    else
      url "https://github.com/fredericrous/aval/releases/download/v1.0.0/aval-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0835b62470a901fbd468bab81810e13404a8d47e99314279449c6e48ca801d40"
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
