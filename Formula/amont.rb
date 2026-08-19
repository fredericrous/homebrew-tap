# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.7.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.7.2/amont-1.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "164cf732c8a8ad557eeeb9105d49485cc1568096ef09e9de4af575c2de7750a9"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.7.2/amont-1.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "f8be912f815a7bf36777f6e0c65bc6f53938eae658e29b13aad5ea91e8da951f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.7.2/amont-1.7.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d4f3bc0fac3f0c46931dccea0f6d9d33f67d147f81647dfa8b802d58bcb01d34"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.7.2/amont-1.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af5e308f130983ffc53fb4e13005ac2831802202fd5a562e3d15ab6bff4c4f98"
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
