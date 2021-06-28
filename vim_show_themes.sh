#!/bin/sh
# Shell script to list installed Vim themes, then launch them in VIM using a
# "less" macro

vim -R -c 'so $VIMRUNTIME/macros/less.vim'
