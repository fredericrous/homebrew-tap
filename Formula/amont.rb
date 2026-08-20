# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.13.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.0/amont-1.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "08f7025ce8cd286210a55d846ea15f37f27f8224b3318f0b1d97c3ed71d17867"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.0/amont-1.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "16425efa9aaa9f899cd5cf913dd639e53b63698a112597384e1a445b33f5c67a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.0/amont-1.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "63da8f07a955ef08d072761f18f7a35bc44ecf2edccf79ef4f464b17375c660b"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.0/amont-1.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ffed05102730124ae36f6afa4d1ec15d729f62215d66aa932188af2687e1e596"
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
