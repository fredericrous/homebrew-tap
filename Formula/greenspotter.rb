class Greenspotter < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/greenharness/greenspotter"
  version "0.20.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.0/greenspotter-0.20.0-aarch64-apple-darwin.tar.gz"
      sha256 "83619b8c0c695f8bfc991ce18f2591934e586ccd7d8accc27db0c5dc92417bb8"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.0/greenspotter-0.20.0-x86_64-apple-darwin.tar.gz"
      sha256 "61e4c1bd1a8d40737f6c8a6880a2b7521b4215168cc7422db346f157c4fe7aca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.0/greenspotter-0.20.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "76c5c5933e640fafd8f92bff2979a1a2ac87b3e6952c6d1abb89bae50dcbd289"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.0/greenspotter-0.20.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f189d5a10fd7d94f2a08947d2292420417eecec490d15633e18d78a167becfc8"
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
