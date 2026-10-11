# bash completion for git-exclude                          -*- shell-script -*-
#
# Completes both `git exclude ...` and `git-exclude ...`. Install as
# ~/.local/share/bash-completion/completions/git-exclude: git's completion lazy-loads
# it the first time `git exclude` is completed, and bash-completion loads it for
# `git-exclude` by name. Sourcing it from .bashrc also works.

# cur is set by git's completion before calling this
# shellcheck disable=SC2154
_git_exclude() {
	case "$cur" in
		-*)
			__gitcomp "--edit --help"
			return
			;;
	esac

	# Patterns are matched from the top of the working tree, so offer untracked paths
	# relative to it rather than to the current directory
	local top
	top="$(__git rev-parse --show-toplevel 2>/dev/null)" || return
	__gitcomp_file "$(__git -C "$top" ls-files --others --exclude-standard --directory --no-empty-directory 2>/dev/null)" "" "$cur"
}

# Completing `git-exclude` directly needs git's completion helpers loaded first
if ! declare -F __git_complete >/dev/null; then
	if declare -F _comp_load >/dev/null; then
		_comp_load git
	elif declare -F __load_completion >/dev/null; then
		__load_completion git
	fi
fi
if declare -F __git_complete >/dev/null; then
	__git_complete git-exclude _git_exclude
fi
