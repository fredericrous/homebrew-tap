class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.14.0/adr-lint-0.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "1c2a7da8f5742f534821bff6b2f3b3ed524c7e20a53de0cdffa11e5785fe3b0d"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.14.0/adr-lint-0.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "50dfbe4e4a649ccf4a93551a726ee33de10b148100e71d5018d1147edf13c961"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.14.0/adr-lint-0.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06b515079f5bff1e590568fe64dacb1dc562f79694569d642bb5e428aa718ddf"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.14.0/adr-lint-0.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5a60de86017b7f265a0fd48319877947b205e303c032db7f437086a2145330cb"
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
