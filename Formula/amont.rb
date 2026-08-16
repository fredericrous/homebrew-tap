# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.6"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.6/amont-1.6.6-aarch64-apple-darwin.tar.gz"
      sha256 "8e5b0dc638955d231ebb38f45b0c6089f9bff2f3186126e3e57948e3e778300c"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.6/amont-1.6.6-x86_64-apple-darwin.tar.gz"
      sha256 "f6d095f40e556f07ef447867d8795a84ae4ad31df007f3bfb23704248fa36945"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.6/amont-1.6.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7dd2fd7711a2fbd6bf15d0f3f2acfad3915e6d09c93f79a184a532d6ae590a45"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.6/amont-1.6.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ae70f7c4505e0dbfba32b8a8c596fef4ece32123e1fb28ca431e5260220eb5f9"
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
