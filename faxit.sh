#!/bin/sh

# -l modem line, -n normal rez vs. fine rez
SENDFAX="/usr/sbin/sendfax -l ttyS0 -n"
FAXDIR="/home/crapola/faxes"

sendfax () {
    # check the status of the last run command; run a shell if it's anything
    # but 0
    FAX_NUMBER=$1
    FILE=$2
    $SENDFAX $FAX_NUMBER $FAXDIR/$FILE 2>&1
    if [ $? -ne 0 ]; then
        echo "Previous fax to ${FAX_NUMBER} failed with status code: ${?}"
        exit 1
    else
        echo "Previous fax to ${FAX_NUMBER} sent successfully"
    fi
    sleep 30s
} # sendfax

    echo -n "Starting fax run at: "
    date
    #Refinance #1 (14Oct2006 11:49, fn5313129S0)
    sendfax 1-877-301-7629 fn5313129S0.g3

# R.I.P.
# Affordable Life Insurance #1 (11Oct2006 16:11, fn52d7a16S0)
# 1-866-849-1818 fn52d7a16S0.g3
# disconnected, 04Nov2006

# Affordable Life Insurance #2 (02Nov2006 20:49, fn54aca1dS0)
# sendfax 1-877-301-7630 fn54aca1dS0.g3
# faxed message back saying I was removed on 09Nov2006 @ 07:19
# saved as ff55346d0S001.png
