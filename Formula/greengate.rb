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
  version "4.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greengate/releases/download/v4.11.0/greengate-4.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "ce46582610c1e860e03d3c60d13937fa4d54ff5814375979f8e894a753255c49"
    else
      url "https://github.com/greenharness/greengate/releases/download/v4.11.0/greengate-4.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "e29a24b6c683f74f4c6c05139cd802b03dec05b54901b23ae097b483720b326f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/greenharness/greengate/releases/download/v4.11.0/greengate-4.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "84711bc2e3eecb8b12573015e5d7a5670e111c95c63fd97b2e28793348d2436a"
    else
      url "https://github.com/greenharness/greengate/releases/download/v4.11.0/greengate-4.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9ec35bb93f439f33fb137a886cdd226eb7979b346bfe946ea85500f2aeba709a"
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
