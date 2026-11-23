class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.19.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.19.0/adr-lint-0.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "f93c6021a05b1203c17e7c5f984e5a4a64544af767511b87a843c07b5f962bcc"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.19.0/adr-lint-0.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "7b1aef3cf8e3e29499356d5a1614e7cc5cb47eaf31563eb5b340f9c9b2b354ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.19.0/adr-lint-0.19.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0403121bd640a6f09021091adf8bbc0d0d880f9a210c1515a9ad9a7e5627771e"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.19.0/adr-lint-0.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "18b917c2d6a3c0fc16740765ba14a09eb96bd821cc0e2efbc6e9e99a32bfc1e6"
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
