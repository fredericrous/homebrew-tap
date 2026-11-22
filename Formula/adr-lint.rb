class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.18.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.1/adr-lint-0.18.1-aarch64-apple-darwin.tar.gz"
      sha256 "467bbadcf9aa83dc13efa0b44f3f87d9dc37fc94e288605aba1167342082883e"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.1/adr-lint-0.18.1-x86_64-apple-darwin.tar.gz"
      sha256 "7e9cbf16d78adc147a7f207dd8566012b77b8be68b9efae40136810ca047a341"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.1/adr-lint-0.18.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ad4c29d735a5c338bfc45680f39337ba68a9c52a5c96bd054d2a87380677f3c0"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.1/adr-lint-0.18.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b94456e77da4386ccdc72ffb4d6be75b654d2de4825b758523b186e6d7d70bda"
    end
  end

  def install
    bin.install "adr-lint"
  end

  def caveats
    <<~EOS
      `adr-lint check` and `adr-lint candidates` need ast-grep at the version
      named in AST_GREP_VERSION (0.51.0 at this release). Install it with
      `brew install ast-grep` or from https://github.com/ast-grep/ast-grep/releases.
      This formula does not depend on ast-grep: that dependency can pull in a
      source build of Python.
    EOS
  end

  test do
    assert_match "adr-lint #{version}", shell_output("#{bin}/adr-lint --version")
  end
end
