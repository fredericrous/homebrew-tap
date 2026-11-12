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
  version "0.58.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.58.0/relais-0.58.0-aarch64-apple-darwin.tar.gz"
      sha256 "71a50b519106767725d0afc9c0e4078f750e2081c8eecd5dd5e16e69e946dc57"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.58.0/relais-0.58.0-x86_64-apple-darwin.tar.gz"
      sha256 "fd2b539ea47ed5fb44c8d263c68624bab00324af01fd5d2535e4cf21b677f14e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.58.0/relais-0.58.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2353b5dc2a9323b16bab4bdad13d4f4bb21c50933bf83cd6ee1dd7e3ae69e2e2"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.58.0/relais-0.58.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "149caf0d8064438bd68a5b8c110852d6e022510c3e2ce278dd82a0493a6a44b9"
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
