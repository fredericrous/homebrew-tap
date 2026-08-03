# Homebrew formula for githooks.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Githooks < Formula
  desc "Git hooks that judge what you are committing, not what is on disk"
  homepage "https://github.com/fredericrous/githooks"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.0/githooks-1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "f0f7d0cc7710bce856e0c4fd5da2b89f67ec28bedd63a281461b3ada58bbea91"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.0/githooks-1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "06cd666f329b8c4af077bc4f70ac2af0959b75b2def0132f06c5a6dd4b9e25a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.0/githooks-1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ad04e05c1edecd08a1e3bcf717283f963d181f6a0f3bed295ccb2974760ff501"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.0/githooks-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "67477020651efb2826658b3a82fc10634a413d95c9475c5e44eddb0d39c2ef4a"
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
