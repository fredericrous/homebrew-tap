# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.1/amont-1.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "4218d7bcb05c133c629eb5a9cb30615810d933e901fb3aeb0f92909b0b6425eb"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.1/amont-1.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "fe8d19f3b705ead7282fddcc3f19b7fb5415e7eec574fea72acc1d00accdb8a4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.1/amont-1.6.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1f52d8590f19657f658413a1e78ed0863e0968a7ffb78d05e9123fc74819cd91"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.1/amont-1.6.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc41bee5e71fc6a0f06e507e4a743b9c49a40e5f8fce96c5bf61c823a713130c"
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
