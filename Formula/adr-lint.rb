class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.16.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.16.0/adr-lint-0.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "cb5cc1121880460aec185467af65e14067dbc656fb5440934c6a2b342d336a92"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.16.0/adr-lint-0.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "6550c9eff45873888d1fe82bd265e8ce7e72ebd6a2baf1f3cad939a40c3efdba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.16.0/adr-lint-0.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "34ef55f8b5883415e580548388134ab1fd2fc0e8b1c177be3c03dd3bee010c69"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.16.0/adr-lint-0.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e155c0ef0c88cb04a87ac6aed2deabb5806bd91ad9673cf3358ed03d7c71fd2"
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
