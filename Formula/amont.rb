# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.9/amont-1.6.9-aarch64-apple-darwin.tar.gz"
      sha256 "55be4cfc1163fedde1e969fee608038356e080e07697f0b0d3c26930f5938cf7"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.9/amont-1.6.9-x86_64-apple-darwin.tar.gz"
      sha256 "d8ce729279bba7f94b24059be61c50e56b897774b9eff60f88aaf0f55b06dac5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.9/amont-1.6.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "162f4ac03039836c83d6dc0539b61e578e68d2a9a89c2888195835aa99157151"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.9/amont-1.6.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "659e45780dbd80ae409ebcdae812019877d9ccdbf67701b5d5115eac23ac33c1"
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
