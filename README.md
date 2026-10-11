# Git Exclude

Add patterns to the repository's `info/exclude` file.

Patterns in `info/exclude` ignore files just as patterns in a `.gitignore` do, but
the file is not part of the working tree, so it is never committed or shared. It
suits files that only matter to one clone, such as editor settings or local scratch
files.

```
git exclude [-e | --edit] [<pattern>...]
```

Each pattern is appended on its own line, unless the file already has an identical
line. With `-e`/`--edit`, or with no patterns, the file is then opened in the
editor, chosen as for `git commit` from `GIT_EDITOR`, `core.editor`, `VISUAL` and
`EDITOR`.

## Examples

Ignore local editor settings:

```console
$ git exclude .vscode/ '*.swp'
```

Ignore a scratch file and review the exclude file:

```console
$ git exclude --edit /scratch.txt
```

Open the exclude file to edit it by hand:

```console
$ git exclude
```

## Patterns

Patterns use [gitignore](https://git-scm.com/docs/gitignore) syntax and are
written as given, so they are matched relative to the top of the working tree,
not the directory the command is run from. A pattern with no slash, or only a
trailing one, matches at any depth; one with a slash at the start or in the middle
matches only from the top:

```
*.log       any file ending in .log, anywhere
build/      any directory named build, anywhere
/build/     only the build directory at the top
docs/notes  only docs/notes at the top
```

Shell completion offers untracked paths relative to the top for this reason.

Empty patterns, patterns containing a newline, and patterns starting with `#`
(which git would read as a comment) are rejected; write `\#` to match a name that
starts with `#`. Patterns that start with `-` must follow `--`.

## Worktrees and other layouts

The file is found with `git rev-parse --git-path info/exclude`, so the command works
from any subdirectory, from a linked worktree, and with `GIT_DIR` or a `.git` file
pointing elsewhere. Linked worktrees share the main repository's `info/exclude`,
since that is the only one git reads, so a pattern added from any worktree applies
to all of them. Git's global options such as `-C`, `--git-dir` and `-c` work as
usual with `git exclude`.

Excluding a path has no effect on files that are already tracked; remove them from
the index with `git rm --cached` first. Bare repositories are refused, since they
have no working tree.

## Install

Requires bash, git 2.31 or later, and util-linux (enhanced) `getopt`.

Download and unpack a [release](https://github.com/EvanDurfee/git-exclude/releases),
then copy the files into place:

```sh
install -Dm755 bin/git-exclude ~/.local/bin/git-exclude
install -Dm644 man/git-exclude.1 ~/.local/share/man/man1/git-exclude.1
install -Dm644 completions/git-exclude.bash ~/.local/share/bash-completion/completions/git-exclude
install -Dm644 completions/_git-exclude ~/.local/share/zsh/site-functions/_git-exclude
```

`~/.local/bin` must be on `PATH` for `git exclude` to find the command, and the zsh
directory must be on `fpath` before `compinit` runs. The man page is then available
as `man git-exclude`, or `git help exclude`.

## Development

Tools are managed with [mise](https://mise.jdx.dev) and tasks with
[just](https://just.systems):

```sh
mise install
just lint            # shellcheck the script and bash completion, syntax-check the zsh completion
just build           # build man/git-exclude.1 from man/git-exclude.adoc
just release 0.1.0   # tag and push v0.1.0, which publishes the release
```

## License

[Mozilla Public License 2.0](LICENSE.md)
