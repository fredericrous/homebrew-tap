class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.2.0/adr-lint-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "0179b5ef9547153c56fe8178db6f154964d888dc7e62f704954ca28816614cf7"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.2.0/adr-lint-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "7d95a99932924f073d97571314060298e08b67ff47d96acb5370ede22eb92f67"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.2.0/adr-lint-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb47b997e2a07bd1da12c44df91d172fa5a8f4b10a6135b4137b67bfb522614e"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.2.0/adr-lint-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f3eae2bb31a68d15dc196db87f2485af454bd2105f141523e558a0a5409fe3ef"
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
