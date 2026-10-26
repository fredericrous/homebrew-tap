class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.0/adr-lint-0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "3f6d588bbae5a5018c9d210f4652e0dbfea1299dceb732386dd149c6971f090e"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.0/adr-lint-0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "de427c8a669cbadfae6e568b451df457cc81b827015e6c651a490fadfe53d4ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.0/adr-lint-0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "500f945fb9184f3fa77c371598a00e1a82f925e7b154ba7f848abd7716652e5b"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.8.0/adr-lint-0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4298718e843d5253ed84a64a4b7ed98ee5bab5bd3dc0d0bd1aeb59920d92be03"
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
