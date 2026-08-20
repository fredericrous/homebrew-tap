# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.13.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.3/amont-1.13.3-aarch64-apple-darwin.tar.gz"
      sha256 "7147e253b135a11d8ab37f823aa974f9345a2278f38d0add897d3d3a41b88e93"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.3/amont-1.13.3-x86_64-apple-darwin.tar.gz"
      sha256 "872c5daf41f944fa6043b6950a534f740177d541d22d08990b9c965e86222f60"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.3/amont-1.13.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "28316bada61204db431fc90c24fc50bf2dbfd4286ef7d315b27ff3e8b1828e7b"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.3/amont-1.13.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab7dd9bf61b1f2ec963c6e5b46a26a5b0ee1f90b24189efcec8ae349f670d1b2"
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
