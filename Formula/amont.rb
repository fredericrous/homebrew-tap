# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.4/amont-1.6.4-aarch64-apple-darwin.tar.gz"
      sha256 "ae349792e7fcf67c1e1b62da8d4b85b03f36c3b33bca34ab49220c6a51fa8fd0"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.4/amont-1.6.4-x86_64-apple-darwin.tar.gz"
      sha256 "a3636d878475e0c0e9e75614a3cde645b3472a80615becf9c9baab38b16bd5f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.4/amont-1.6.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5028c7df875043949f31a2dc06e2c22345ba06339b1b94dd2ecfbce93fb29aae"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.4/amont-1.6.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43a10e8047b3f295a8c75c9d49fc64b50ef8642635f583a1c640fe3bb19713ee"
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
