# Homebrew formula for githooks.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Githooks < Formula
  desc "Git hooks that judge what you are committing, not what is on disk"
  homepage "https://github.com/fredericrous/githooks"
  version "1.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.2/githooks-1.0.2-aarch64-apple-darwin.tar.gz"
      sha256 "b4567f4a293f9d547407a800d22d268d7042da7ae3f36bafb8654a2526d1ae16"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.2/githooks-1.0.2-x86_64-apple-darwin.tar.gz"
      sha256 "3eabd87aa9194a4db15e1d701fc19b694bd477bea8650ffd042f53bcde5600a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.2/githooks-1.0.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "df5c03d0129bc44d7e38a6e3c3a35024c1ae8a6d94d95599a7a0007b2d316a06"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.2/githooks-1.0.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41572cc28bd4331d2ddd6923ac92c2c4c7b6b9871ef5db2144b47307d322955e"
    end
  end

  def install
    bin.install "githooks"
    bin.install "githooks-fleet"
    # The four shims, for anyone pointing `init.templateDir` at a checkout
    # instead of installing per repository.
    pkgshare.install "templates"
  end

  def caveats
    <<~EOS
      Nothing is enabled yet, on purpose. To turn the hooks on:

        cd <your-repo> && githooks install     # this repository only
        githooks list                          # what would run here
        githooks uninstall                     # and back out again

      Across many repositories at once:
        githooks-fleet install --root ~/Developer
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand that only this tool has.
    assert_match "agents-md", shell_output("#{bin}/githooks --help")
    # And the binary can answer a real question in a real repository.
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match "pre-commit", shell_output("cd #{testpath}/repo && #{bin}/githooks list")
  end
end
