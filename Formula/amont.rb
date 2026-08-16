# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.7"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.7/amont-1.6.7-aarch64-apple-darwin.tar.gz"
      sha256 "a499ecf0e00cf904c52256b0fc66446dc77e8deae1d121a8eeed8d8518398d1a"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.7/amont-1.6.7-x86_64-apple-darwin.tar.gz"
      sha256 "2c4981e4b00c04387bc2963df7843a0fcbadf18910a198ff96d83f7129f44e83"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.7/amont-1.6.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21bd8cd5e74e6220ae056b87eaffb12c7529ea1432f65fe07c47bba40849fe07"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.7/amont-1.6.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8efefec3091f24100030710b3fa52503480e4002367793bd2a62f18c2b634ac4"
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
