# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.7.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.7.4/amont-1.7.4-aarch64-apple-darwin.tar.gz"
      sha256 "8a63ac7f541110801b05fe833ec08459aa8c70fac64bf275b04fca59a4b56f1e"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.7.4/amont-1.7.4-x86_64-apple-darwin.tar.gz"
      sha256 "df44170a10c4129ad2ce5ecb407b475e6f2d1b369e38facf2d1ddcb3e8e780a6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.7.4/amont-1.7.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "df2f0c6f7316eebc935feaf0ed59328877926b469c048deb84abe385a6c8bb69"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.7.4/amont-1.7.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9019e0d2b131d63398aeec2115435fccbc4856906000dc4ae5bdaa9642435aa3"
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
