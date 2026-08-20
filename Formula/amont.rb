# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.14.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.14.0/amont-1.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "fe8c96e9295ddf2d570770eac11368be8c02aca12dba6852fbabb17d17c37215"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.14.0/amont-1.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "f2c333811d78bf646eae2935ea0c061a1cd051537755bb2e66536719b178fbe4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.14.0/amont-1.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f57c1acf5071be5a9d2bb3fab4356597ad0dc743d023025f58748d999fc7d275"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.14.0/amont-1.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c07e8013d0e6b8f8e8bbf403eb6321ac277895d30f1f4b0d2482b78833a0dcf"
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
