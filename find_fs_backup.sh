#!/bin/sh

# massive system find for making a list of files to back up

/usr/bin/find / \
! -path [proc|ftp/other|lost\&found|mnt|ssldocs/libro] \
> ~/fs_list.txt
