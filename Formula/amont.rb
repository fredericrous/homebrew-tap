# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.20.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.20.0/amont-1.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "0e416e9d5eba4abcae16bc1ca58c6e2e66aaead568d77915f7bf7e04f16ce580"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.20.0/amont-1.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "167877496c1a01dd8e75a37cd64637f250c3818a99eea202afc972aff8e02d68"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.20.0/amont-1.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c34d8f107659f6bfae1fc7631f6ef487108361927d529ecea28ad29043caa164"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.20.0/amont-1.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6ca64ce123f0020b801dd0fb4a8757a4e98ce27a12d72edcb6b6e666ffd9e6f6"
    end
  end

  def install
    bin.install "amont"
    bin.install "amont-fleet"
    # The Claude Code guard. It is in every release archive and in both
    # shell installers; leaving it out here made brew the one install path
    # that produced a partial toolchain, so `amont-agent` had to be dropped
    # into ~/.local/bin by hand and then drifted a version behind.
    bin.install "amont-agent"
    # The five shims, for anyone pointing `init.templateDir` at a checkout
    # instead of installing per repository.
    pkgshare.install "templates"
  end

  def caveats
    <<~EOS
      First install: nothing is enabled yet, on purpose. To turn the hooks on:

        cd <your-repo> && amont install     # this repository only
        amont list                          # what would run here
        amont uninstall                     # and back out again

      Across many repositories at once:
        amont-fleet install --root ~/Developer

      And the Claude Code guard, which reads a shell command before the
      agent runs it (separate from the git hooks above):

        amont-agent install --write        # adds the hook to settings.json
        amont-agent doctor                 # is it actually armed?

      After an upgrade: the hooks already run this binary — they are baked to
      #{HOMEBREW_PREFIX}/bin/amont, so nothing per repository needs redoing
      for the checks themselves. Two things do not update on their own: a
      repository's hook shims when a release changes them, and the generated
      block in AGENTS.md/CLAUDE.md, which an agent reads and believes. Both
      show as drift, and one command sees all of it:

        amont-fleet fix --root ~/Developer              # dry run: what drifted
        amont-fleet fix --root ~/Developer --apply --agents-md

      or, in one repository: amont install && amont agents-md
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand that only this tool has.
    assert_match "agents-md", shell_output("#{bin}/amont --help")
    # And the binary can answer a real question in a real repository.
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match "pre-commit", shell_output("cd #{testpath}/repo && #{bin}/amont list")
    # All three binaries are installed, and the guard can reach a verdict —
    # `rules` is the cheapest question that proves it loaded its rule table.
    assert_match "pipe-to-tail", shell_output("#{bin}/amont-agent rules")
    assert_match version.to_s, shell_output("#{bin}/amont-fleet --version")
  end
end
