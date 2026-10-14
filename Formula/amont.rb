# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.52.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.52.0/amont-1.52.0-aarch64-apple-darwin.tar.gz"
      sha256 "d536baf8521ef355dedcb8dc80f5caf54df2c6443a772814ca3ba2a7c5ceffb5"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.52.0/amont-1.52.0-x86_64-apple-darwin.tar.gz"
      sha256 "ac8b282f485a5e02cf2474bd23f8bb4c2b382eed71ca189f9961a11980fa151c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.52.0/amont-1.52.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "930200a8a13a7dd36eff58321a1d6dbcb806e637b6cbd186b37876b04f2882e7"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.52.0/amont-1.52.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e590a78e0e5cba766d232096413a9b69ea2796de63c8a6946049b822ee728d63"
    end
  end

  def install
    bin.install "amont"
    bin.install "amont-fleet"
    # NO amont-agent. It became its own project in amont 1.20.0
    # (github.com/fredericrous/amont-agent) and is no longer in this
    # archive. This line outlived the binary by three releases and broke
    # every `brew install` and `brew upgrade` in between — bin.install on a
    # file that is not there aborts the whole formula, so the failure was
    # total rather than partial. Nothing caught it because the release
    # verified the tarball and the formula's checksums, and never once ran
    # brew.
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

      The Claude Code guard that used to ship here is its own project now:
        brew install fredericrous/tap/amont-agent

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
    # BOTH binaries this formula installs — amont-agent moved to its own
    # project in 1.20.0 and testing it here would fail for the same reason
    # installing it did. `brew test` is the only thing in this repository
    # that runs the installed artifact, so what it names is what is checked.
    assert_match version.to_s, shell_output("#{bin}/amont-fleet --version")
  end
end
