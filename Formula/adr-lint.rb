class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.18.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.0/adr-lint-0.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "22bf71c403f1de4eaecc25c064cbe0a2fe04940ea7ba0b9902a9226ba8b433d4"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.0/adr-lint-0.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "072890c10a2cd7c79053145f7eee21afcfe3ab9321a66a3c9145868c16032b61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.0/adr-lint-0.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "96e0ca1b38cf3403bb73fadd2dd1085c5281ffcd0cc49a0c3f73a40dcbe86ea8"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.18.0/adr-lint-0.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "05940f69e11c4f4b2d7b81af16dc7dcc1f2479c2904ad96028713794ed71ce29"
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
