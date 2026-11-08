class AdrLint < Formula
  desc "Checks a tree against the decided code rules a linter matches exactly, and marks candidate lines for reviewers (ADR-0044)"
  homepage "https://github.com/fredericrous/adr-lint"
  version "0.17.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.17.0/adr-lint-0.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "5e8caa567fcb110d242eaad5b908f9863bad3af772dbb3e2cb017274bbc233d3"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.17.0/adr-lint-0.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "e6d495d97c3f12d314b27aea57f1164d16701851ee56428369aaf2c29c786b14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.17.0/adr-lint-0.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "17282fe138c814a01b89865653ef1c309983823d220003efcf35799bff685b79"
    end
    on_intel do
      url "https://github.com/fredericrous/adr-lint/releases/download/v0.17.0/adr-lint-0.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3cd150e8539c733c84bb6c21092beb35700f54b5ddbc7ea1ee5b6b588b921b46"
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
