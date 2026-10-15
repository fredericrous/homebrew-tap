# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.55.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.55.1/amont-1.55.1-aarch64-apple-darwin.tar.gz"
      sha256 "e55b022fcc86bc7f74f33720413805b911038d47a626123ef405fd5165630dee"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.55.1/amont-1.55.1-x86_64-apple-darwin.tar.gz"
      sha256 "a9de72ca52c1913de04b2f1937007670fcb21418fd27502c5f38468cb9ecd100"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.55.1/amont-1.55.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e8d4db6a18ad57c74adf0d575052c2e247b11757494bcbd6984fa31df2f2885"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.55.1/amont-1.55.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "96f66e5f8ad1004f8792fe323631af30fff73b2a557c4d1c5233ec84c04b3f0f"
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
