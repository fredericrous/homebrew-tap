# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.1.0/amont-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "e83ef4de2a6724fc181192c5a85b6c09249a3fc90e695c5019db60879fcb187e"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.1.0/amont-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "b0fd8b5a387ad222eea6655861563984779b0223d1218f978a909b8104e2ce57"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.1.0/amont-1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "139ac7d87a027475a332c32d80bd41b1fe8934a46fea4b4d15dce6a4a523abfd"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.1.0/amont-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0e3519377b6746db1d7a7e47050a1be920edc9aab066f180c812e565df6a3770"
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
