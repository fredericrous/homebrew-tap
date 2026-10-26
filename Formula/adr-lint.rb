class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.7.0/adr-lint-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "8dca7e43db502012e0c546938f263298d9b57924d75745aaecf436986bd3fb7a"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.7.0/adr-lint-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "3c665044f2f73d0223cb052681dd5e62cd976aa1e77c21c1e4dc004577ccceb6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.7.0/adr-lint-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe691dd09e0a4be9d9dce8c5a8fc3b4b47567ae6868bff6106f465d5a4f456c4"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.7.0/adr-lint-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f393bfca0885b3b8795aad177873d020077eccaeb74886e025a218db96176e3e"
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
