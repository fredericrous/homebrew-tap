class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.15.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.1/adr-lint-0.15.1-aarch64-apple-darwin.tar.gz"
      sha256 "14a6d236e8ec19575fe931dbb4d0bf3ef1c242afd44dc6eb8f446ff6c2a8312f"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.1/adr-lint-0.15.1-x86_64-apple-darwin.tar.gz"
      sha256 "831e5d807da2fe4561683cc9f91e643180cfadd503f47f93f524eb2bef71ddf0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.1/adr-lint-0.15.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "73fed59e07bdbe612a65df297f2a0fb885648c8f7bbb946974c6165c26d8c741"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.1/adr-lint-0.15.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0bba9192870a14518e13487a44625d362a10098525f5dbed06154d50747ea463"
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
