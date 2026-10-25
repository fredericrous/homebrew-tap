class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.1.0/adr-lint-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "29c3e9deb5d9fd66850d487896bf0b718e083faec9075c9fb4b549f30388ed8b"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.1.0/adr-lint-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "2efc49540d7c506b73f76cf363449a52db9d257e3cadee692a34d33c75d83467"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.1.0/adr-lint-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e08d30ede4ea51204d19d3ce71cc1edff317120493ae155009c7d82e80b19761"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.1.0/adr-lint-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9fd9518d1c8a0211ff71d5e7c39c5d2e9fcfdd9a465dfce6c537a062d0aa4aa"
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
