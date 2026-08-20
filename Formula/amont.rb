# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.11.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.11.1/amont-1.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "6b756c973124f0eb225001d98645ccbee27fee22d37ed9dcab59dad642ae46ff"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.11.1/amont-1.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "7dc9e7a265e52de80767904c6103f4da7a8d9439bb463f98fe30f4a48fc8065b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.11.1/amont-1.11.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "84291670905ec8ca0ae8ed6f71625788106259bfb653ac8ba66d6389637f84eb"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.11.1/amont-1.11.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "39a64cfac91c025b89f75acb57244a3d27e129224eaffc2ccccef3730bc11f67"
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
