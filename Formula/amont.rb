# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.3/amont-1.6.3-aarch64-apple-darwin.tar.gz"
      sha256 "db61a6ee58bb382f772de7791a09628518363faa24e62cb149fff677690262d8"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.3/amont-1.6.3-x86_64-apple-darwin.tar.gz"
      sha256 "932fee94f1eb445ba74ef9edec72a1dbe4cb2993e8536955036b646fac18627e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.3/amont-1.6.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1de02590cfabe3bd0daf9b9d2326fb816629b354fd99de6b846dd801e5eb9889"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.3/amont-1.6.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ebc1610f818a17be9a8124ca7162c1514835b6f3a5a4effe4c99498b198c518e"
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
