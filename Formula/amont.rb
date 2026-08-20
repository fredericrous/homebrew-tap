# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.12.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.12.0/amont-1.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "200eef31b6ea310e1e252ba92134c6d7fdcc1234ff89f7ab51f006bf9c3c5adc"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.12.0/amont-1.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "8eb327ca04fc8ae307369a7bc6fcccdafbe209b4581743b843031160fad87213"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.12.0/amont-1.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7ea48ad18b9d54c7fbe82083a9fe5b6a67c5d700b87061d0b338138f5008effb"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.12.0/amont-1.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7370d8e58ebf5d469b9fee5dbb96e930873dcd400b30fcfae4f3416a895b258f"
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
