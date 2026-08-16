# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.6.5"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.5/amont-1.6.5-aarch64-apple-darwin.tar.gz"
      sha256 "c3a71e6d1c62ef9b4c4aff56f29275c7af568854ac86dd97452a7dd3eb0f5fb7"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.5/amont-1.6.5-x86_64-apple-darwin.tar.gz"
      sha256 "4517a6f583edc450e6fcd531cd845379e57601073f4d68cb86f1728fa3f95377"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.6.5/amont-1.6.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "956da59bd5fd1e87d5beec491a941b5834bfe23a0ed9cf0d027aa182377b0be2"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.6.5/amont-1.6.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10679d6fc2d8ba5a79c964dd6602fe6e222acb95ea0c7d81529ffc20c269bdeb"
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
