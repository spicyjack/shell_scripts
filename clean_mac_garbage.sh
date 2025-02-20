#!/bin/sh

#echo "Disabling Spotlight searches for this volume"
#sudo mdutil -i off /Volumes/VOLUMENAME
#sudo mdutil -X /Volumes/VOLUMENAME

# creating this file causes spotlight to skip indexing this disk
touch .metadata_never_index
# delete the gunk
rm -rf ._.Trashes
rm -rf .fseventsd
rm -rf .Spotlight-V100
rm -rf .Trashes
