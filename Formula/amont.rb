# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.15.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.15.0/amont-1.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "6b846020ed4796edc03d2e8493b48c743d13ceb0268c24a25761760cafc4ac0b"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.15.0/amont-1.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "eaabac6a5bdb8dee138a64a7166a9ee1929c01234f9effa711db11f514b97f19"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.15.0/amont-1.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "371bbeec0a6cf83d0b693fdf4bb6628ce59e4c14783d763c11c2eea408823166"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.15.0/amont-1.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6e863524c04c9ae309eb13a2e405a8c9616dce91bd2a7fcdb6ea0a792c3baf2e"
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
