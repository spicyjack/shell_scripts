#!/usr/bin/env bash
#
# repo_sync.sh - run `git pull`, `git push` or `git status` in every
# *.git directory found in the current directory.  The `graph`
# subcommand runs the `git graph` alias (see ~/.gitconfig) and shows
# the first few lines of its output.
#
# Usage: repo_sync.sh {pull|push|status|graph}

set -euo pipefail
shopt -s nullglob

graphLines=5

usage() {
    printf 'Usage: %s {pull|push|status|graph}\n' "${0##*/}" >&2
    exit 64    # EX_USAGE from sysexits.h
}

[[ $# -eq 1 ]] || usage

case "$1" in
    pull|push|status|graph) gitCommand="$1" ;;
    *) usage ;;
esac

repoDirs=( *.git/ )

if [[ ${#repoDirs[@]} -eq 0 ]]; then
    printf 'No *.git directories found in %s\n' "$PWD" >&2
    exit 1
fi

printf 'Running "git %s" in %d repo(s) under %s\n' \
    "$gitCommand" "${#repoDirs[@]}" "$PWD"

failedRepos=()

for repoDir in "${repoDirs[@]}"; do
    repoDir="${repoDir%/}"
    printf '\n==> %s\n' "$repoDir"

    if ! git -C "$repoDir" rev-parse --is-inside-work-tree \
            >/dev/null 2>&1; then
        printf 'Skipped: not a Git working tree\n' >&2
        failedRepos+=( "$repoDir" )
        continue
    fi

    if [[ "$gitCommand" == graph ]]; then
        if ! git -C "$repoDir" rev-parse --verify --quiet HEAD \
                >/dev/null 2>&1; then
            printf '(no commits yet)\n'
            continue
        fi

        # head closes the pipe early, so git may die with SIGPIPE (141).
        graphStatus=0
        git -C "$repoDir" log --oneline --decorate --graph \
          | head -n "$graphLines" ||
            graphStatus=${PIPESTATUS[0]}
        if [[ $graphStatus -ne 0 && $graphStatus -ne 141 ]]; then
            failedRepos+=( "$repoDir" )
        fi
    elif ! git -C "$repoDir" "$gitCommand"; then
        failedRepos+=( "$repoDir" )
    fi
done

printf '\n'

if [[ ${#failedRepos[@]} -gt 0 ]]; then
    printf 'Failed or skipped: %s\n' "${failedRepos[*]}" >&2
    exit 1
fi

printf 'Done: "git %s" succeeded in all repos.\n' "$gitCommand"
