# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.13.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.2/amont-1.13.2-aarch64-apple-darwin.tar.gz"
      sha256 "5678e2da5ce8f1daff1c0ab87f199fc0127cf8f569bf19a571dd7d5c57415786"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.2/amont-1.13.2-x86_64-apple-darwin.tar.gz"
      sha256 "187f513216441e2aace89b39f718af4668f068d722e5d22e99cdffac0bb93565"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.13.2/amont-1.13.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c34ef7c95a6860235936da06947f126a413fa25610dd464ca8b20e4ab3690d79"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.13.2/amont-1.13.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b0add007c1194b5e39e422ababf57233b670043f7a32942ad6a7eb5362211098"
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
