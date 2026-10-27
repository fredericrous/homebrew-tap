class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.1/adr-lint-0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "7573f7fc44d57c35827b656eea75796e14639692d652f4bd676d6ea50954a7a2"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.1/adr-lint-0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "67daca4c31b580e8de5e8b2d5169a875ea861224fa42d426126c77120ee1a806"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.1/adr-lint-0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e754a3873a78e7efbc72266c286ce9ada361c0f2dcef796e7a000200df7e8845"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.1/adr-lint-0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d6edc40bc9fd669206c2fc8185355291da38918c56a3234fe3f23415803430a9"
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
