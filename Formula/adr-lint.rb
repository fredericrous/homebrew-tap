class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.5.0/adr-lint-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "f1971728130c5d45dbe6f26f22dee4592aa1b0deff10c8f1bfe8e08fa0497f27"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.5.0/adr-lint-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "832e0085a59b3d09be6d78e901916e387a3f9ece978e592631ea642e8195c097"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.5.0/adr-lint-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba4d90bb7fae13629c5aa6057e40d8ed97b059ab53729c947570e4eb75519ff2"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.5.0/adr-lint-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "671e16a2f0e8f6512bfb0e2ac89e8f0dfbfef730a27f7b3ee60876e952f43145"
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
