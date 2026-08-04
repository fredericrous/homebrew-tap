# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.3.0/amont-1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "b2923b920c11a40a759de142276e2fa94247524efd566992de350e4c6d601e62"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.3.0/amont-1.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "e1b7dfc5112bc767ba5cb4d84c0b0ad053372ad84f012922f62bfca501269fe7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.3.0/amont-1.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c25e0f96fd64cdcd4197e21a12ce2e93eca8a99f5ac2f36589265a7aa9eb78cb"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.3.0/amont-1.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0ba24b24773985997830fe700d055e0447c86b817d6df894b11f56dc524772be"
    end
  end

  def install
    bin.install "amont"
    bin.install "amont-fleet"
    # The four shims, for anyone pointing `init.templateDir` at a checkout
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
