# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.9.0/amont-1.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "cf2c9e6fe4c9d8ec54e57c3e5e16fb12b97373e159529ceab1dc7cd13d7bbb89"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.9.0/amont-1.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "1cc02d2387448453b464c21a18c02472a8cbe763c9a1a0d118504c070ce180a8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.9.0/amont-1.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f85e18d6079983ac9db5b014ca4c024ba6bbc53ca44c69834feb1d7eb6fc87c3"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.9.0/amont-1.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c8d3ad45e6a98bc1aa7673690275e26c633c9f66ae492229d1bfc9057ebd285"
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
