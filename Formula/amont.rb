# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.18.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.18.0/amont-1.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "2ef8dd6e2fdb2f4a36c6bf55440f25d59bd331cc765e0e68d086e652631ef1e2"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.18.0/amont-1.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "f836ff704223df7d3ae2a3d6c81794917a2a71adc57aa71b1c400e9b9ed339e8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.18.0/amont-1.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4a87411590e951e9ed8fe4dc3264d41e140363d58415c7ee4a356e9fea6fb90b"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.18.0/amont-1.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "09e750b72900f7f8654c154b2336f0aca65b873dce0d1388d9d5bb72d81d91f4"
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
