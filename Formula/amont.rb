# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.2.0/amont-1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "4e0dfcae642218dc6bed16fde941330697d11c7c938546180f0d1f41438ed7be"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.2.0/amont-1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "e558dfcf9ec1438caf26f6e01257fc6875b6319177b0f3c9868e87c6d9825efb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.2.0/amont-1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ffbe45af5158d4ba852c5ae1a70d96efdeb806262a6829d4eb4fdd3c0038abc4"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.2.0/amont-1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db85ee34272abb1f7566d73be1ec0bce42dd8ee629d2b89ec7efdebf9dfab515"
    end
  end

  def install
    bin.install "amont"
    bin.install "amont-fleet"
    # The four shims, for anyone pointing `init.templateDir` at a checkout
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
