# fredericrous/homebrew-tap

Homebrew formulae for [githooks](https://github.com/fredericrous/githooks).

```sh
brew tap fredericrous/tap
brew install githooks
```

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
