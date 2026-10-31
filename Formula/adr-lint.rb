class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.13.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.13.0/adr-lint-0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "0ebc6860682e6e48bd7384457722e5d9c21686a6c17aee01fef8a5f2769fcad8"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.13.0/adr-lint-0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "1524f42e16c4eeaebbddac018e4221cbdd13d7252c780531db61e7139ba42387"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.13.0/adr-lint-0.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d2f1a985b916963bfccfb12bdbca4b295b024c8055b64c83a5ebdda228cb37c"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.13.0/adr-lint-0.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bd3a6c0e10e7be3ffb850f87c87b540d1848cf83ee787430b93744bf40033e1b"
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
