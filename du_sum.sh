#!/bin/bash

# script to sum up multiple lines of du output

#[observer][root ~]$  du -sx /home/cvs/ /var/cvs/ /home/tennsat/ /home/drkerr/
#/home/kpri/ /var/lib/mysql/ /home/ssc_org/ /home/ssc_com/ /home/wsd/
#/home/ssldocs/ /home/affm/ /home/brian/[a-zA-Z]* | cut -f 1 | perl -e
#'while(<STDIN>){$sum +=$_;} print $sum."\n";'
#787856
#[observer][root ~]$  du -sx /home/cvs/ /var/cvs/ /home/tennsat/ /home/drkerr/
#/home/kpri/ /var/lib/mysql/ /home/ssc_org/ /home/ssc_com/ /home/wsd/
#/home/ssldocs/ /home/affm/ /home/brian/[a-zA-Z]* | perl -ne '/^ *([0-9]+)/ and
#$sum += $1; if (eof()){print("$sum\n");}'
#787856

#/usr/bin/du -sx \
#/home/cvs/ /var/cvs/ /home/tennsat/ /home/drkerr/ /home/kpri/ /var/lib/mysql/ \
# /home/ssc_org/ /home/ssc_com/ /home/wsd/ /home/ssldocs/ /home/affm/ \
#/home/brian/[a-zA-Z]* | \
#perl -ne '/^ *([0-9]+)/ and $sum += $1; if (eof()){print("$sum\n");}'

# du -s combos/ deathmatch/ docs/ graphics/ historic/ incoming/ levels/ lmps/
# misc/ music/ newstuff/ prefabs/ roguestuff/ skins/ sounds/ source/ themes/
# utils/ | awk '{total += $1}; END { print "total disk usage is", total}'

/usr/bin/du -sx \
/home/cvs/ \
/var/cvs/ \
/home/tennsat/ \
/home/drkerr/ \
/home/kpri/ \
/var/lib/mysql/ \
/home/ssc_org/ \
/home/ssc_com/ \
/home/wsd/ \
/home/ssldocs/ \
/home/affm/ \
/home/brian/Documents/ \
/home/brian/junk/ \
/home/brian/mail/ \
/home/brian/public_html/ | \
perl -ne '/^ *([0-9]+)/ and $sum += $1; if (eof()){print("$sum\n");}'

