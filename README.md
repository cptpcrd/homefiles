# homefiles

Some of my dotfiles and scripts.

My "real" dotfiles repository is private. This is a collection of scripts that I use on e.g. shared machines; it gets my dotfiles to a usable state that I can work with.

These are designed to, as much as possible, work on Linux and \*BSD (there's untested support for macOS). The only required dependencies are `git` and `bash`.

## Installation

```
git clone https://github.com/cptpcrd/homefiles.git ~/homefiles && ~/homefiles/update.sh -f
```

Remove `-f` to avoid overwriting existing files (even with `-f`, they will be renamed to `.old`, not removed).
