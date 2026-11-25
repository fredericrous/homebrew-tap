class Greenspotter < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/greenharness/greenspotter"
  version "0.20.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.1/greenspotter-0.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "2163991646d3b1243d8a695956f178c640bcbd3e658a3a6fda374b0a38235856"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.1/greenspotter-0.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "f2815ba76bf6be244f412ea39ce1c6df272a5243b64edc8aa4029a823a089b0a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.1/greenspotter-0.20.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e06b9bfe9332399624b08a6643d2ad3460564628137d0e8f63cd83d8c26d4442"
    end
    on_intel do
      url "https://github.com/greenharness/greenspotter/releases/download/v0.20.1/greenspotter-0.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f14ec614e7304ef716b27ef8301f60d9295739e0a149399474c4f29b30a64c6b"
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
