# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.10.0/amont-1.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "4ef15df519ce232736f319cf8a87ff50612d359258eda2aef81af7156df8b810"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.10.0/amont-1.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "8195c2158eb58fcac8585917d53534664c0ad2c53c243c39cadcc6db20527d5c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.10.0/amont-1.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "35e287b94231f9693239e4d927f9a6afd17c51ddcdb039a4097bc7fa56bd98da"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.10.0/amont-1.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "284ec13cd6921086bbc9fd55aaaf0cd7cbb819c987bca6d44d1d6f5ebe9cf839"
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
