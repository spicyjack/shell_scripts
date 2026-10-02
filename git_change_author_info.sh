#!/bin/sh

# as swiped from https://help.github.com/articles/changing-author-info/
#
# Be kind, don't rewrite Git history (unless the other people working on the
# project with you agree)

echo "WARNING: script disabled because 'git filter-branch' is broken"
echo "Please see https://trundlebits.com/posts/2026/rewrite_git_history_change_user_name_and_email/#tldr-git-filter-repo-instructions for more info"
exit 1

git filter-branch --env-filter '
OLD_EMAIL="old@example.com"
CORRECT_NAME="Example Uer"
CORRECT_EMAIL="new@example.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
