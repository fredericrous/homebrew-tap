class Greenspotter < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/greenharness/greenspotter"
  version "0.21.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.21.0/greenspotter-0.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "900f6cd1f3a2b5f3c85fecb780b7e6224c46304176f4442638137ad31f634947"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.21.0/greenspotter-0.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "ee4eaec31b77b7b0b0793f9e2c83efc51aa8da9e7ce2ebdd91d0a353bf98f9ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.21.0/greenspotter-0.21.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d18d107f3c1098ca4776aa4f416706ebe5982001ce89996b58c712fd09a4a80d"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.21.0/greenspotter-0.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d3c64d7773a321b8dae93094ae4d6e3242ced7a8362c66a9307caf2cb28927e"
    end
  end

  def install
    bin.install "greenspotter"
  end

  def caveats
    <<~EOS
      `greenspotter check` and `greenspotter candidates` need ast-grep at the version
      named in AST_GREP_VERSION (0.51.0 at this release). Install it with
      `brew install ast-grep` or from https://github.com/ast-grep/ast-grep/releases.
      This formula does not depend on ast-grep: that dependency can pull in a
      source build of Python.
    EOS
  end

  test do
    assert_match "greenspotter #{version}", shell_output("#{bin}/greenspotter --version")
  end
end
