# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.2/amont-1.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "58ce9a191f8bbe628a22ffcd348228e1a847d90c4c98942a0725b281d7fa6c87"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.2/amont-1.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "42095ec6511141e2bda4aefa67b7fb39c6250a07e873b9ebada81d7d1cd311cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.2/amont-1.6.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "414992bcb2b33d2b8e834131b18fc87e1bd746930f2f3a94c7bf6ba0bd145f46"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.2/amont-1.6.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "217879f9278cad258a3a2cc32e3a526a755be0ba9213d7a539cac463c73e6575"
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
