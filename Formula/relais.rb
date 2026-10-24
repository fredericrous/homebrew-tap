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
  version "0.30.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.30.0/relais-0.30.0-aarch64-apple-darwin.tar.gz"
      sha256 "19985b2ff782a22057e46233a12de7c36de5e6d6ede6a02f9c9e39364fbe49cb"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.30.0/relais-0.30.0-x86_64-apple-darwin.tar.gz"
      sha256 "b2741b89b0fec1fa1d141c29bff5e753dd397b168799dce11e6f9ccde33292c1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.30.0/relais-0.30.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb362222318111864b90d7a9c3af04523845444f1ee126eb186b0dd8dd7b1d63"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.30.0/relais-0.30.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f0293e1b9e48fc945483d477e1f5c09913ebd2baf6aed1b026d433af65482198"
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
