# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.10"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.10/amont-1.6.10-aarch64-apple-darwin.tar.gz"
      sha256 "9609342bb9f09a47bc22fb8396513938ff558e7b485c54becd3e5f939bd4dd31"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.10/amont-1.6.10-x86_64-apple-darwin.tar.gz"
      sha256 "0f1238de908a20c28b1c63f8a54d2504bff9983f45d3f883a10d8ecde8a0731d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.10/amont-1.6.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "46733015f2b2e66b936d796bcee7b1d51cb39f3d1e3ce73efa839a3d83997422"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.10/amont-1.6.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e8f4bbaa24e74aca2f6e831dedb73dcaa118e8038f2fbc79ac3edb09344c5050"
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
