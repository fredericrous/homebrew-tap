# Homebrew formula for greengate, formerly amont.
#
# The source of truth for Formula/greengate.rb in fredericrous/homebrew-tap:
# the release's `publish-tap` job copies this file there, rewrites its
# version and its four url/sha pairs from the release's own SHA256SUMS
# (scripts/bump-tap.py), records the rename amont -> greengate in the tap's
# formula_renames.json and removes Formula/amont.rb, all in one tap commit
# made after the release assets exist.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them, and `brew install` compiling a Rust
# toolchain's worth of dependencies to arrive at the same bytes helps nobody.
class Greengate < Formula
  desc "Git hooks that catch the bad commit before it exists"
  homepage "https://github.com/greenharness/greengate"
  version "5.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greengate/releases/download/v5.1.0/greengate-5.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "02ba9b7dcda0409419885ec7625f72d3a0594d0e437c1f0cd22d75b8b7bbec71"
    else
      url "https://github.com/greenharness/greengate/releases/download/v5.1.0/greengate-5.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "18a145663710a0c82b51047cab4edb3d5c512bbed676f7351ce8efb7d0aeb4c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greengate/releases/download/v5.1.0/greengate-5.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "435e6083c5534be23291e9bd75ae76b74f118e7b04f922aab2d294e8d1ba9c96"
    else
      url "https://github.com/greenharness/greengate/releases/download/v5.1.0/greengate-5.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d634dcb48e366b814859d48d51426b2fab691017391522599017048d24906448"
    end
  end

  def install
    # The old names as COPIES, so shims a 2.x install baked to
    # #{HOMEBREW_PREFIX}/bin/amont keep running this build. Copies, never
    # links, the same rule `greengate install` follows.
    cp "greengate", "amont"
    cp "greengate-fleet", "amont-fleet"
    bin.install "greengate", "greengate-fleet", "amont", "amont-fleet"
    # The shims, for anyone pointing `init.templateDir` at a checkout instead
    # of installing per repository.
    pkgshare.install "templates"
  end

  def caveats
    <<~EOS
      amont is now greengate. `amont` and `amont-fleet` are installed too, as
      copies of greengate and greengate-fleet, so hooks baked to the old name
      keep running this build.

      First install: nothing is enabled yet, on purpose. To turn the hooks on:

        cd <your-repo> && greengate install     # this repository only
        greengate list                          # what would run here
        greengate uninstall                     # and back out again

      Across many repositories at once:
        greengate-fleet install --root ~/Developer

      After an upgrade: a repository's hook shims and the generated block in
      AGENTS.md/CLAUDE.md do not update on their own; one command sees both:

        greengate-fleet fix --root ~/Developer              # dry run
        greengate-fleet fix --root ~/Developer --apply --agents-md
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand that only this tool has.
    assert_match "agents-md", shell_output("#{bin}/greengate --help")
    # And the binary can answer a real question in a real repository.
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match "pre-commit", shell_output("cd #{testpath}/repo && #{bin}/greengate list")
    # Every binary this formula installs, the old names included.
    assert_match version.to_s, shell_output("#{bin}/greengate-fleet --version")
    assert_match version.to_s, shell_output("#{bin}/amont --version")
    assert_match version.to_s, shell_output("#{bin}/amont-fleet --version")
  end
end
