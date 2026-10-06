#!/usr/bin/env bash
#
# repo_sync.sh - run `git pull`, `git push` or `git status` in every
# *.git directory found in the current directory.  Directories that
# are not working trees (including bare repos) are skipped.
#
# The `graph` and `log` subcommands show recent history for each
# repo: `graph` shows the first few lines of a decorated one-line
# graph, `log` shows the last few commits, three lines each: ISO 8601
# date and author, short commit ID with tags/branches, and the title
# line.
#
# Usage: repo_sync.sh {pull|push|status|graph|log}

set -euo pipefail
shopt -s nullglob

outputLines=5      # graph: lines shown per repo
outputCommits=3    # log: commits shown per repo

# Use color only when the output stream is a terminal (not a pipe or
# file), and honor the NO_COLOR convention (https://no-color.org).
useColor() {
    [[ -t $1 && -z "${NO_COLOR:-}" && "${TERM:-dumb}" != dumb ]]
}

colorHeader=''
colorReset=''
if useColor 1; then    # stdout
    colorHeader=$'\e[34m'
    colorReset=$'\e[0m'
fi

errColor=''
errColorReset=''
if useColor 2; then    # stderr
    errColor=$'\e[33m'
    errColorReset=$'\e[0m'
fi

usage() {
    printf 'Usage: %s {pull|push|status|graph|log}\n' "${0##*/}" >&2
    exit 64    # EX_USAGE from sysexits.h
}

[[ $# -eq 1 ]] || usage

case "$1" in
    pull|push|status|graph|log) gitCommand="$1" ;;
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
    printf '\n%s==> %s%s\n' "$colorHeader" "$repoDir" "$colorReset"

    # Bare repos print "false" here but still exit 0, so test the value.
    if [[ "$(git -C "$repoDir" rev-parse --is-inside-work-tree \
            2>/dev/null)" != true ]]; then
        if [[ "$(git -C "$repoDir" rev-parse --is-bare-repository \
                2>/dev/null)" == true ]]; then
            skipReason='bare repository (no working tree)'
        else
            skipReason='not a Git working tree'
        fi
        printf '%sSkipped: %s%s\n' \
            "$errColor" "$skipReason" "$errColorReset" >&2
        failedRepos+=( "$repoDir" )
        continue
    fi

    if [[ "$gitCommand" == graph || "$gitCommand" == log ]]; then
        if ! git -C "$repoDir" rev-parse --verify --quiet HEAD \
                >/dev/null 2>&1; then
            printf '(no commits yet)\n'
            continue
        fi

        case "$gitCommand" in
            graph)
                # head closes the pipe early, so git may die with
                # SIGPIPE (141).
                logStatus=0
                git -C "$repoDir" log --oneline --decorate --graph \
                    | head -n "$outputLines" || logStatus=${PIPESTATUS[0]}

                if [[ $logStatus -ne 0 && $logStatus -ne 141 ]]; then
                    failedRepos+=( "$repoDir" )
                fi
                ;;
            log)
                if ! git -C "$repoDir" log -n "$outputCommits" \
                        --format='%cI %an <%ae>%n%h%d%n%s%n'; then
                    failedRepos+=( "$repoDir" )
                fi
                ;;
        esac
    elif ! git -C "$repoDir" "$gitCommand"; then
        failedRepos+=( "$repoDir" )
    fi
done

printf '\n'

if [[ ${#failedRepos[@]} -gt 0 ]]; then
    printf '%sFailed or skipped: %s%s\n' \
        "$errColor" "${failedRepos[*]}" "$errColorReset" >&2
    exit 1
fi

printf 'Done: "git %s" succeeded in all repos.\n' "$gitCommand"
