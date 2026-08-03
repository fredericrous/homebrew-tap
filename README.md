# fredericrous/homebrew-tap

Homebrew formulae for [githooks](https://github.com/fredericrous/githooks).

```sh
brew tap fredericrous/tap
brew trust fredericrous/tap    # Homebrew requires this for any third-party tap
brew install githooks
```

Without the `brew trust` line, Homebrew refuses with *"Refusing to load formula
from untrusted tap"*. That is Homebrew's policy for every tap outside its own
core, not something specific to this one — a formula is code, and running it is
a decision it now asks you to make explicitly. The same reasoning the tool
itself applies to a repository's declared checks.

Installing does **not** enable anything. Hooks are turned on per repository,
by you, afterwards:

```sh
cd <your-repo> && githooks install
githooks list         # what would run here, and why not
githooks uninstall    # and back out again
```

The formula installs prebuilt, checksummed binaries from the
[releases](https://github.com/fredericrous/githooks/releases) rather than
building from source.
