# Homebrew formula for relais.
#
# Prebuilt binaries rather than a source build, for the same reason greentopo's
# and greengate's formulae give: the release workflow already produces and
# checksums them, and compiling a Rust toolchain to arrive at identical bytes
# helps nobody. The sha256 values below are the ones published in SHA256SUMS.
#
# Rewritten by scripts/bump-tap.py in the relais repository, which ASSERTS it
# found four url/sha pairs and a version line rather than hoping a regex
# matched. Keep that shape: four pairs, one `version`, no other release URL.
class Relais < Formula
  desc "Coding-agent execution companion: routing, context, verification, accounting"
  homepage "https://github.com/fredericrous/relais"
  version "0.93.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.93.0/relais-0.93.0-aarch64-apple-darwin.tar.gz"
      sha256 "f37289eff3cdddb7212b14af6b790af6b5e7becde7d6dd4409b5fcd3f41738a8"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.93.0/relais-0.93.0-x86_64-apple-darwin.tar.gz"
      sha256 "b2273a94642e8891438644d7e8119dc4973306f45b374947eeb9ec117363799e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.93.0/relais-0.93.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba242768aa1dd51246f7fcfdb54ebbbbdb4c683902d0297badb69a17b3b78a93"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.93.0/relais-0.93.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b587b3e0cddc01413d04ddad9277f16a6e2bef3d585233612cfc2662cbf70da4"
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
