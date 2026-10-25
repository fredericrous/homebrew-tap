class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.3.0/adr-lint-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "0b8743968a95d3f34e10d2bfe5bf8d60a67f435a12beb45e7224ffb35f13ea58"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.3.0/adr-lint-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "c7c016a16c6a8d36f2e65038b4c77371d2f0a4655df67570408e6b46a142be39"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.3.0/adr-lint-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36481d4a4d60eec44c826400ee9e6ffae8b95adf96447f14ab685ebc2c0d9263"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.3.0/adr-lint-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "03331daf3d58a98733ce756e9a6db9c9c668dc783aba60c02bbee9f628a80fc3"
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
