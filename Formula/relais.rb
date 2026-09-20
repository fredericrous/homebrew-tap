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
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.1.1/relais-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "bc1680665b4079cbc351dbd3baf6d7950eed7c1d5ce90b36ae8e61a099279afc"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.1.1/relais-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "e2a9af0fa23ab00ef01b94185cf30e2175b203058e23944a2c2d8f1e3ea2f244"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/relais/releases/download/v0.1.1/relais-0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e7113553958d201abb78a3811affd6ef7f18897e95bc4919f3cbcfd33ff4957"
    else
      url "https://github.com/fredericrous/relais/releases/download/v0.1.1/relais-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a6eccb9eaed85fb0067c339ce11a5dc0fc6e0cb58f1c6955a68f0aa9193dccc"
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

      The trust grant and the worker permission allowlist live in
      ~/.config/relais/machine.toml — see the README. The specification is
      #{doc}/SPEC.md.
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
    assert_match "wrote relais.toml", shell_output("cd #{testpath}/repo && #{bin}/relais init")
    assert_match "schema_version = 1", (testpath/"repo/relais.toml").read
    assert_match "never overwrites", shell_output("cd #{testpath}/repo && #{bin}/relais init 2>&1", 2)
  end
end
