# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.34.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.34.1/amont-1.34.1-aarch64-apple-darwin.tar.gz"
      sha256 "b1d4edf30c6218193a2d01a3a8215a164bed33fe60b95c5f0749df236c1a5185"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.34.1/amont-1.34.1-x86_64-apple-darwin.tar.gz"
      sha256 "838668be8fac8a252ee6a956ceec9d9ba833ec940b7c248cc8931fa33339d1e1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.34.1/amont-1.34.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d4de092cbead2db613907e64f3c14b9dd105e2943d7e5114cc807cf3d252e2ce"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.34.1/amont-1.34.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6ec29045c4c56a6d7dceda31c5b47f3db32abaea9b6e382d90a753332b67a8e"
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
