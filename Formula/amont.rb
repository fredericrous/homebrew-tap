# Homebrew formula for amont.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Amont < Formula
  desc "Git hooks that catch the bad commit before it exists — en amont"
  homepage "https://github.com/fredericrous/amont"
  version "1.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.11.0/amont-1.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "0af5ac730b464b562934379ecb44e5581db97d07b0319e86c66ce35ffa16f1c6"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.11.0/amont-1.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "2f0a7658d5ec6ad3f83c1757ff438450714ec7ea03c6a5b29f0c933d0ef7acb4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/amont/releases/download/v1.11.0/amont-1.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "93db2034d102d838578e680939efb9605065944788fc49119cb2b912432a1c72"
    else
      url "https://github.com/fredericrous/amont/releases/download/v1.11.0/amont-1.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "655b3c992d793299a508c73c5bad2c86ca7eb02bb750dbaa9b724bac09656cfe"
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
