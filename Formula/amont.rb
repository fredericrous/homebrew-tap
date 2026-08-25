# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.17.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.17.0/amont-1.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "a1a8e23a457c84ba356378cea9787869cc872f6a2fa1fda9ad2266466c2167de"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.17.0/amont-1.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "b8ae62382b31599e0158331ed39f81f60cfb2c1d1999c545f51000e2a34aace7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.17.0/amont-1.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aaf1d33cba3486c4e5b9adde66a3e4ac2f20f9c1f30f81d94697a693ee19a071"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.17.0/amont-1.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8cab0b4a4fb7c1668dcd6506c4e6e661cb8c84b4509f518c6f984cec6558f0d3"
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
      Nothing is enabled yet, on purpose. To turn the hooks on:

        cd <your-repo> && amont install     # this repository only
        amont list                          # what would run here
        amont uninstall                     # and back out again

      Across many repositories at once:
        amont-fleet install --root ~/Developer

      And the Claude Code guard, which reads a shell command before the
      agent runs it (separate from the git hooks above):

        amont-agent install --write        # adds the hook to settings.json
        amont-agent doctor                 # is it actually armed?
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
