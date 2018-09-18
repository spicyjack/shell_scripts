#!/bin/sh

# as swiped from https://help.github.com/articles/changing-author-info/
#
# Be kind, don't rewrite Git history (unless the other people working on the
# project with you agree)

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
