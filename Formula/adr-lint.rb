class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.12.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.12.0/adr-lint-0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "290c626f3501cb83e6381872b8fb77a3a16d1a1d895feb518865bfd8a3a2efbc"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.12.0/adr-lint-0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "0022df60429e963e742f8891e989a485df75bb140d1b3a04ec2e00c1f9855f55"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.12.0/adr-lint-0.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "163e82e561c003792a78569c0efc7c09262e277457af24cd5cda1894ee26bc49"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.12.0/adr-lint-0.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "88f1c721533e2efd1b5c589ace46cde2eb8628203e05275785d433fd9bff5ed5"
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
