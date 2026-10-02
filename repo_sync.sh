#!/usr/bin/env bash
#
# repo_sync.sh - run `git pull`, `git push` or `git status` in every
# *.git directory found in the current directory.
#
# Usage: repo_sync.sh {pull|push|status}

set -euo pipefail
shopt -s nullglob

usage() {
    printf 'Usage: %s {pull|push|status}\n' "${0##*/}" >&2
    exit 64    # EX_USAGE from sysexits.h
}

[[ $# -eq 1 ]] || usage

case "$1" in
    pull|push|status) gitCommand="$1" ;;
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

    if ! git -C "$repoDir" "$gitCommand"; then
        failedRepos+=( "$repoDir" )
    fi
done

printf '\n'

if [[ ${#failedRepos[@]} -gt 0 ]]; then
    printf 'Failed or skipped: %s\n' "${failedRepos[*]}" >&2
    exit 1
fi

printf 'Done: "git %s" succeeded in all repos.\n' "$gitCommand"
