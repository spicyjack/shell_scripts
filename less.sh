#!/bin/sh
# Shell script to start Vim with less.vim.
# Read stdin if no arguments were given.

if test $# = 0; then
  vim -R -c 'so $VIMRUNTIME/macros/less.vim' -
else
  vim -R -c 'so $VIMRUNTIME/macros/less.vim' "$@"
fi
