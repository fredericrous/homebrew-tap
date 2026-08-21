# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.16.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.16.0/amont-1.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "b46ce6cee0e22b05b5bbe7329ab88d7a2a696b65678b510bcf8262754d21edf8"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.16.0/amont-1.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "c9239f3de2bdbda5a6cf26790f485f340e969a9d47d88dd194513a90ae3acc22"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.16.0/amont-1.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "926f218809043a0fb3b715296a77207f34bf6e770f1a9f1ec265a3d0799209c6"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.16.0/amont-1.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f24219628bb5acaff4e11181caa86e4b3afca9851b3cf1d4586ebad3b3ea2b85"
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
