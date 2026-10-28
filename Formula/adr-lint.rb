class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.9.0/adr-lint-0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "47cc03777193837baa82d405351e82a2bacf04b428b4c149962120886d0ba4c3"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.9.0/adr-lint-0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "e115bc10784a6d498c1e7e56ff716989e45a69ad490bca6c4d462b49efda6bed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.9.0/adr-lint-0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9c0208dcc2f44f6d81aa877a870334807c2ded7520cd0d2e171df9b51037fa7b"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.9.0/adr-lint-0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57e518bdb35e1722685ec1fbdbd37d9a0e7da07a51f14139bd871026df789196"
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
