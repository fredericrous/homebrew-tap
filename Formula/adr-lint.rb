class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.4.0/adr-lint-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "d6f1f8a4795a45d198724f860dd5d3c73e04e698465b72634ba661d2ada662ff"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.4.0/adr-lint-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "83def7ff8f451d2834fce914896645a0b1b95f5d6e5d3965602f221c3660b5a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.4.0/adr-lint-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bd0f1fbc9c48350e6f2c00f23e1661cf524699e0ed63c2bcfde11a570e63b862"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.4.0/adr-lint-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c73d6dcadf5c667c84d65ae17286924f0930bc0ae5c4603ba6ee6143ad8055fc"
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
