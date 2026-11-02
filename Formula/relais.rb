# Homebrew formula for relais.
#
# Prebuilt binaries rather than a source build, for the same reason aval's
# and amont's formulae give: the release workflow already produces and
# checksums them, and compiling a Rust toolchain to arrive at identical bytes
# helps nobody. The sha256 values below are the ones published in SHA256SUMS.
#
# Rewritten by scripts/bump-tap.py in the relais repository, which ASSERTS it
# found four url/sha pairs and a version line rather than hoping a regex
# matched. Keep that shape: four pairs, one `version`, no other release URL.
class Relais < Formula
  desc "Coding-agent execution companion: routing, context, verification, accounting"
  homepage "https://github.com/fredericrous/relais"
  version "0.48.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.48.0/relais-0.48.0-aarch64-apple-darwin.tar.gz"
      sha256 "6b4d183099a5df3bd22758c99f2bd4dfc28664a917011932b88b937d2fe8534d"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.48.0/relais-0.48.0-x86_64-apple-darwin.tar.gz"
      sha256 "2b2696106487f18628caf143e7d7fca3f24a5515acb6acf42cc6e6d5b01dda45"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.48.0/relais-0.48.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "854d8071d7124dca89cafbfc28ae132035db3354ab86c08610f28aac937e7037"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.48.0/relais-0.48.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "854dc65d62e1f39c476936389af4858a3832defe2e70dbe701ed89d844dc816a"
    end
  end

  def install
    bin.install "relais"
    doc.install "SPEC.md"
  end

  def caveats
    <<~EOS
      relais runs nothing until a repository has a policy and your machine
      has granted it trust. In a repository:

        relais doctor                    what is installed and what is missing
        relais init                      write relais.toml, then commit it
        relais plan --task task.json     the route, and the authority hash to trust

      Runs start from Claude Code, through the relais plugin. Install it,
      and remove an older relais hook wiring, once:

        relais install --claude --hooks --user --write

      The trust grant lives in ~/.config/relais/machine.toml — see the
      README. The specification is #{doc}/SPEC.md.
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand only this tool has.
    assert_match "doctor", shell_output("#{bin}/relais --help")
    assert_match version.to_s, shell_output("#{bin}/relais --version")
    # And it does a real thing in a real place, rather than only proving
    # the binary starts: `init` writes the policy file, and refuses to
    # write it twice (exit 2, by contract).
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match %r{wrote \S*/relais\.toml}, shell_output("cd #{testpath}/repo && #{bin}/relais init")
    assert_match "schema_version = 1", (testpath/"repo/relais.toml").read
    assert_match "never overwrites", shell_output("cd #{testpath}/repo && #{bin}/relais init 2>&1", 2)
  end
end
