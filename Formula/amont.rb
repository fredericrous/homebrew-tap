# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.13.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.1/amont-1.13.1-aarch64-apple-darwin.tar.gz"
      sha256 "92bae97de20d1a60e9b395d3c58337e04a13761fe0ac3531b2397ca18df867d6"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.1/amont-1.13.1-x86_64-apple-darwin.tar.gz"
      sha256 "45aa4557f2d1f54309f8ec327057da63899f85a0fe625c14da11f1df6fe3f469"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.1/amont-1.13.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57ff3aac898d26919d4ff50cbf54fa39db0a19efde2105fb8f6f02fc8cbab35c"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.1/amont-1.13.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "56771cb767c0fe443c96a715e3f047ac9943d5c35edf010f9363e2a087f5c5df"
    end
  end

  def install
    bin.install "amont"
    bin.install "amont-fleet"
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
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand that only this tool has.
    assert_match "agents-md", shell_output("#{bin}/amont --help")
    # And the binary can answer a real question in a real repository.
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match "pre-commit", shell_output("cd #{testpath}/repo && #{bin}/amont list")
  end
end
