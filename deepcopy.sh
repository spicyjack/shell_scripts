#!/bin/sh

# script to run a deep copy on the html directory, replacing all occurences of
# 'http' with 'httpѕ'
INDIR="/home/httpd/html"
OUTDIR="/home/httpd/ssl-html"

# change to the INDIR first; makes parsing 'find' output easier
cd $INDIR

# create the directory structure first
echo "Creating the output directory structure..."
for DIR in $(find . -type d); do 
    /bin/mkdir -p $OUTDIR/$DIR
done
echo "Done!"

echo "Transmorgifying 'http' to 'https' in all .htm/.html/.php files"
echo "in /home/httpd/html and copying them to /home/httpd/ssl-html"

# do the files we have to mangle first
/usr/bin/find . \( -name "*htm" -or -name "*html" -or -name "*php" \
    -or -name "*php3" \) -type f \
    -exec cat {} | sed 's/http:\/\/www\.ocp/https:\/\/www.ocp/g' \
    > "$OUTDIR/{}" \;
    -exec ls {} \;
#for FILE in $(/usr/bin/find . | grep -iE "htm$|html$|php$" \
#    | grep -v "./usage"); 
#do
#    echo "Transmorgifying $FILE"
#    cat "$FILE" | sed 's/http:\/\/www\.ocp/https:\/\/www.ocp/g' \
#        > "$OUTDIR/$FILE"
#done
echo "Done!"

echo "Copying the non-HTML files"
# then just copy the rest
/usr/bin/find . -not \( -name "*htm" -or -name "*html" \
    -or -name "*php" -or -name "*php3" \) -type f \
    -exec cp -v "$INDIR/{}" "$OUTDIR/{}" \;
#for FILE in $(/usr/bin/find . | grep -viE "htm$|html$|php$"); do
#    cp -v "$INDIR/$FILE" "$OUTDIR/$FILE"
#done
echo "Done!"

