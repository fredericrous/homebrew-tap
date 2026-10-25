class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.6.0/adr-lint-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "9be2803932fbeedb9352c95f3afd0df539a0914bc18ec43ee30a2e0004fa09a6"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.6.0/adr-lint-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "6e19e9b494867f8e93813efea2d790ffd5b1c05dc1a27ceec732e0f898221bc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.6.0/adr-lint-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f791dea5030bb47b31ee171cda376ca7e54049f23d6cb830a06fdc786cdfb6a"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.6.0/adr-lint-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fcb3cdab57efc02628277198e8c725d011cd30be78ae0e93111b538835fbdd08"
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
