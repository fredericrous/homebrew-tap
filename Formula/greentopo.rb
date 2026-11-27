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
  version "3.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greentopo/releases/download/v3.0.0/greentopo-3.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "8d8124573bcdcb78554690add56df2648ab1c442a4c221ed99e2bfb42e310214"
    else
      url "https://github.com/greenharness/greentopo/releases/download/v3.0.0/greentopo-3.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "92beb3a45b85530b3d53bf24ea15e34ab0c0c496c7d9a322eccc0251352de308"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greentopo/releases/download/v3.0.0/greentopo-3.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ef853de429b91fe909830becdd12dfba10a884bd81192280847e5c9793bf18e8"
    else
      url "https://github.com/greenharness/greentopo/releases/download/v3.0.0/greentopo-3.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "65d852abd30d2243ef6316d161aeb4a2854ced6684d6e574f5024c2a5fb5bcc0"
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
