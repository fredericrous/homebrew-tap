# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.8/amont-1.6.8-aarch64-apple-darwin.tar.gz"
      sha256 "a588b3e0acb414a7a22862c6d374b68e2788bc6543f570472961072591f90776"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.8/amont-1.6.8-x86_64-apple-darwin.tar.gz"
      sha256 "1e76cc50faaca62aaf336936a01b0b240ecf8af062dfc24c4a65db970330ddc5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.8/amont-1.6.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "696ce51bbc3914238e685b2a352251c11d1edb4d6a6f9841e20ca83af63e0865"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.8/amont-1.6.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4d61af5b9a66e3d6e7c5075f4cd72e0a1d9113434443b261efd889893702401c"
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
