# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.0/amont-1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "dc4b0a308b42a9717ef7e9c856fa41163b9be9f77c389b8b8e510ab5b5510fc6"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.0/amont-1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "c55c3bed334f1acbccdb264854c59ebf3d8499e9987c11de738fd88fd5101ead"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.0/amont-1.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d007e39fefe673710501747a2b0382f165bf866ed2dbf0b9683750c9d66a5044"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.0/amont-1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "30e3357532114a5cc8699e1664f113b3abe19a09c0fd100e887fac86e9f9e2c1"
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
