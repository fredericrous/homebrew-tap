# Homebrew formula for githooks.
#
# Prebuilt binaries rather than a source build: the release workflow already
# produces and checksums them for six targets, and `brew install` compiling a
# Rust toolchain's worth of dependencies to arrive at the same bytes helps
# nobody. The sha256 values below are the ones published in SHA256SUMS.
class Githooks < Formula
  desc "Git hooks that judge what you are committing, not what is on disk"
  homepage "https://github.com/fredericrous/githooks"
  version "1.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.1/githooks-1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "ea2e252c4e18593a6b04236c8f00080890b37414c8a261721504b5b6cc751096"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.1/githooks-1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "6b3edc00ab98f4589491112cc10341f42da6dceaac9f3a783910a4fd57d204ff"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.1/githooks-1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "00f2c037e9fd7ff2ee8b06c7012c482109e3f7b93cee14934fa42bc781e1073d"
    else
      url "https://github.com/fredericrous/githooks/releases/download/v1.0.1/githooks-1.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "33b80cce95a2a85216db95847e7ed6341c8218bb48366e95e9812fded1e5b4b2"
    end
  end

  def install
    bin.install "githooks"
    bin.install "githooks-fleet"
    # The four shims, for anyone pointing `init.templateDir` at a checkout
    # instead of installing per repository.
    pkgshare.install "templates"
  end

  def caveats
    <<~EOS
      Nothing is enabled yet, on purpose. To turn the hooks on:

        cd <your-repo> && githooks install     # this repository only
        githooks list                          # what would run here
        githooks uninstall                     # and back out again

      Across many repositories at once:
        githooks-fleet install --root ~/Developer
    EOS
  end

  test do
    # `--help` exits 0 and names a subcommand that only this tool has.
    assert_match "agents-md", shell_output("#{bin}/githooks --help")
    # And the binary can answer a real question in a real repository.
    system "git", "init", "-q", "--template=", testpath/"repo"
    assert_match "pre-commit", shell_output("cd #{testpath}/repo && #{bin}/githooks list")
  end
end
