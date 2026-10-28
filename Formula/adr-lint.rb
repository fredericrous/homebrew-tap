class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.10.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.10.0/adr-lint-0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "b74785a59a2288ed93dc3422964ac0125ac2d6e0412756a6b318c600c8e831f2"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.10.0/adr-lint-0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "973420c1801ab80666617de6fe0b6df94fcf1e34c646a2d8513cce56639bd866"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.10.0/adr-lint-0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b909f7d5fd47179f59e70654b7df8b8243f907e30b8e655f50788746c6db9093"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.10.0/adr-lint-0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a945cda1cb28202717c1dd1b5adc0cb7f46405a5c6c6027ca1adc1c5a5ee13bf"
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
