class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.15.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.0/adr-lint-0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "4e81543fe57bc78470d8068f3d5f7f3b431a9d7b219807cd7219934f8e9ac90b"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.0/adr-lint-0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "44cfaec47c74d038c2c65b80aaf303ac83cf09de55fb5f92556af948c40185a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.0/adr-lint-0.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "db99512e97032a26667d8087f5512bdac155c784b5c34f6cfc882d9a42a99030"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.15.0/adr-lint-0.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "257da35a72c0f3a157f84526b25ba94c71a69381d92be7e2caa7dd3e2b0e8b36"
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
