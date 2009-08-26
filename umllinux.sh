#!/bin/bash
# Copyright (c)2004 Brian Manning
# brian (at) antlinux dot com

# runs an instance of User Mode Linux, based on the option switches passed into
# the script

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA 

### Defaults ###
UMLBIN="/home/antlinux/src/uml/linux"

# read in the command line switches
TEMP=$(/usr/bin/getopt -o b:c:fhim:noqt: --long basedir:,count:,floppy,help,initrd,mountdir:,nomakedevs,overwrite,quiet,imagetype: -n 'make_image.sh' -- "$@")

# now add them to this script's environment
# the quotes around temp are important
eval set -- "$TEMP"

# run through all of the passed in switches
while true ; do
    case "$1" in
        -h|--help) 
        cat <<- EOM
        $0:
        -0|--hd0         First [hard drive|ISO] image
        -1|--hd1         Second [hard drive|ISO] image
        -2|--hd2         Third [hard drive|ISO] image
        -3|--hd3         Fourth [hard drive|ISO] image
        -i|--umid        Name of this UML process (used with uml_mconsole)
        -m|--mem         Size in Megabytes for the UML process to use
        -c|--con1        First console port (nitrd image without prompting
        -q|--quiet       suppress script status messages
EOM
        echo "\t-u|--umlbin      UML binary to use (defaults to ${UMLBIN})"
        exit 1;;
        -0|--hd0)           HD0=$2; shift 2;;
        -1|--hd1)           HD1=$2; shift 2;;
        -2|--hd2)           HD2=$2; shift 2;;
        -3|--hd3)           HD3=$2; shift 2;;
        -m|--mountdir)      MOUNT_DIR=$2; shift 2;;
        -n|--nomakedevs)    NOMAKEDEVS=1; shift;;
        -o|--overwrite)     OVERWRITE=1; shift;;
        -q|--quiet)         QUIET=1; shift;;
        -t|--imagetype)     IMAGETYPE=$2; shift 2;;
        --) shift; break;;
    esac
done # while true ; do

#/usr/local/src/antlinux/uml/linux \
#mem=128m umid=initrd con=pty con0=fd:0,fd:1 con1=port:8998 con2=port:8999 \
#ubd2=/usr/local/src/antlinux/uml/Debian-3.0r0.ext2 \
#ubd1=/usr/local/src/antlinux/bf-uml/initrd \
#ubd0=/usr/local/src/antlinux/sid-base.img single

# recurse the script if we're not r00t
if [ $EUID != 0 ]; then
    echo "Error: not root. script is broken unless you're root"
    exit 1
    # FIXME script is not passing args to itself below.  find out why and fix
    # "$@" doesn't exist after getopts is called.  move this stanza back up to
    # the top of the file
    echo "=================================================================="
    echo "Hey! You need to be r00t to run this script (mount/unmount images)"
    echo "executing 'sudo ${0}'."
    echo "Hit Ctrl-C to cancel sudo."
    /usr/bin/sudo $0 "$@"
    exit 0
fi

# check to see if ANT_CVS is set, set it by hand if it's not
if [ ! $ANT_CVS ]; then
    ANT_CVS=/home/brian/cvs/antlinux
    echo "Warning: \$ANT_CVS not defined." 1>&2
    echo "Setting \$ANT_CVS to $ANT_CVS" 1>&2
fi

# check to make sure either --initrd or --floppy was set
#if [ ! $INITRD -o ! $FLOPPY ]; then
#    echo "Oops. Please specifiy --floppy or --initrd. Exiting..."
#    exit 1
#fi

# exit if we don't have a base directory
if [ ! $BASE ]; then 
    BASE=$PWD
    echo "Warning: no base directory passed in"
    echo "Using \$PWD (${BASE}) for base directory"
    echo "Continue? [Y/n]"
	read VAR
	if [ ${VAR} == "n" -o ${VAR} == "N" ]; then
		exit 1
	fi # if [ ${VAR} == "n" ]
fi # if [ -z $BASE ]; then



# if there's no mount directory passed in, set one
# anything that's in the mount directory will disappear for as long as the
# image is mounted to it
if [ ! $MOUNT_DIR ]; then
    MOUNT_DIR=$BASE/mnt 
    if [ -d $MOUNT_DIR ]; then
        echo "Warning: no mount directory passed in. Using ${MOUNT_DIR}"
    fi # if [ -x $MOUNT_DIR ];
fi

# some initrd stuff
if [ $INITRD ]; then
    # check for --imagetype 
    if [ ! $IMAGETYPE ]; then
        echo "Warning: initrd image type not specified.  Assuming modules_all"
        IMAGETYPE=all
    fi
    # if block COUNT is unset, set it
    if [ ! $COUNT ]; then
        # check to see how big the initrd image needs to be
        if [ $IMAGETYPE -eq "all" ]; then
            COUNT=8192 # size in bytes, multiplied by 1k/bytes
        else
            COUNT=4096 # size in bytes, multiplied by 1k/bytes
        fi
        echo "Warning: no image size passed in. Using ${COUNT}"
    fi
    # set the epoch
    # find a free filename
    EPOCH_BASE=$(TZ=GMT date +%Y.%j)
    epochcount=1
    while [ -f "$BASE/initrd.$EPOCH_BASE.$epochcount.gz" ]; do
        eval 'epochcount+1'
        if [ $epochcount -gt 20 ]; then 
            echo "epochcount > 20; exiting"
            exit 1
        fi
    done
    EPOCH="$EPOCH_BASE.$epochcount"
    OUTPUT_FILE=$BASE/initrd
    BLK_SIZE=1024

    # check for an existing initrd
    if [ -f ${OUTPUT_FILE} ]; then
        if [ ! ${OVERWRITE} ]; then
    	    echo "initrd file exists, overwrite? [Y/n]"
        	read VAR
	        if [ ${VAR} == "n" ]; then
		        exit 1
        	fi
        fi # if [ ! ${OVERWRITE} ];
    fi # if [ -f ${OUTPUT_FILE} -o ! ${OVERWRITE} ];

elif [ $floppy ]; then
    # for --floppy
    EPOCH_BASE=$(TZ=GMT date +%Y.%j)
    epochcount=1
    while [ -f "$BASE/floppy.$EPOCH_BASE.$epochcount.img" ]; do
        eval 'epochcount+1'
        if [ $epochcount -gt 20 ]; then 
            echo "epochcount > 20; exiting"
            exit 1
        fi
    done
    EPOCH="$EPOCH_BASE.$epochcount"
    OUTPUT_FILE=$BASE/floppy.${EPOCH}.img
    BLK_SIZE=512
    # if the floppy block count is unset, then set it
    if [ ! $COUNT ]; then
        COUNT=2880
    fi
    # check for --imagetype 
    if [ -z $IMAGETYPE ]; then
        echo "Warning: no floppy image type specified.  Assuming net floppy"
        IMAGETYPE=net
    fi
    if [ $IMAGETYPE == "all" ]; then
        echo "Error: can't use modules_all on a floppy image. Exiting..."
        exit 1
    fi
else 
    echo "Error: --initrd or --floppy not specified"
    exit 1
fi # if [ $INITRD ]; then

# program locations
CP=/bin/cp
DD=/bin/dd
GZIP=/bin/gzip
GREP=/bin/grep
HARDLINK=/bin/ln
LOSETUP=/sbin/losetup
MAKE=/usr/bin/make
MKE2FS=/sbin/mkfs.ext2
MKDIR=/bin/mkdir
MKNOD=/bin/mknod
MKVFAT=/sbin/mkfs.vfat
MOUNT=/bin/mount
RM=/bin/rm
RMDIR=/bin/rmdir
SYMLINK="/bin/ln -s"
TOUCH=/usr/bin/touch
TUNE2FS=/sbin/tune2fs
UMOUNT=/bin/umount

if [ ! $QUIET ]; then 
    echo "= Creating ${COUNT} block blank image with 'dd'"; 
fi
$DD if=/dev/zero of=${OUTPUT_FILE} bs=${BLK_SIZE} count=${COUNT}

if [ ! $QUIET ]; then echo "= Finding free loopback device"; fi
for CHECK in 0 1 2 3 4 5 6 7 8 9
do
	# test to see if that loop device exists; if it doesn't, we should exit out
	# with an error, as there are no free loop devices left
	# test -b is for block devices
	if [ ! -b /dev/loop${CHECK} ]; then
		echo "ERROR: loop device /dev/loop${CHECK} doesn't exist"
		exit 1
	fi # if [ ! -b /dev/loop${CHECK} ]
	# pull the output of losetup into a variable so we can check it
	# enclose variables in braces to ensure substitution
    # is checkloop zero length?
    if ${LOSETUP} /dev/loop${CHECK} 2>&1 | grep "No such device" > /dev/null
    then
        # yep, found a free loopback device 
        LOOP_DEV="/dev/loop${CHECK}"
        if [ ! $QUIET ]; then echo "= Using ${LOOP_DEV} for loopback device"; fi
        # exit this for loop
        break
    fi # if [ -z $CHECKLOOP ];
done # for x in 0 1 2 3 4 5 6 7 8 9 do

if [ ! $QUIET ]; then echo "= Attaching ${OUTPUT_FILE} to ${LOOP_DEV}"; fi
$LOSETUP $LOOP_DEV $OUTPUT_FILE

if [ ! $QUIET ]; then echo "= Creating filesystem on ${OUTPUT_FILE}"; fi
if [ $INITRD ]; then
    # ext2 for initrd image
    $MKE2FS -m 0 -N 1500 -L $EPOCH $LOOP_DEV
    if [ ! $QUIET ]; then 
        echo "= Tuning initrd image, turning off filesystem checking"; fi
    $TUNE2FS -c 0 -i 0 -e remount-ro $LOOP_DEV
else
    # vfat for floppy image
    if [ -x $MKVFAT ]; then
        $MKVFAT -n ${EPOCH} $LOOP_DEV
    else
        echo "Hmmm.  It seems mkfs.vfat is not installed. "
        echo "Please install Debian package 'dosfstools'.  Exiting..."
        exit 1
    fi
    # give the floppy image some syslinux luvin
    SYSLINUX=`which syslinux`
    if [ ! -x $SYSLINUX ]; then
        echo "Error: can't find syslinux binary in your \$PATH. Exiting..."
        exit 1
    else 
        $SYSLINUX $LOOP_DEV
    fi
fi 

if [ ! $QUIET ]; then 
    echo "= Removing image file from loopback device ${LOOP_DEV}"; fi
$LOSETUP -d $LOOP_DEV

if [ ! $QUIET ]; then echo "= Mounting ${OUTPUT_FILE} to ${MOUNT_DIR}"; fi

# another initrd specific section
if [ $INITRD ]; then
    # mount the image file as an ext2 filesystem    
    $MOUNT -t ext2 -o loop $OUTPUT_FILE $MOUNT_DIR

    if [ ! $QUIET ]; then 
        echo "= Removing 'lost+found' directory on the new image"; fi
    $RMDIR $MOUNT_DIR/lost+found

    # all of the binary directories need to exist for the busybox installer to
    # work correctly
    if [ ! $QUIET ]; then 
        echo "= Creating directories on new initrd image"; fi
    $MKDIR -p $MOUNT_DIR/bin $MOUNT_DIR/dev $MOUNT_DIR/etc/init.d \
    $MOUNT_DIR/lib/modules $MOUNT_DIR/mnt $MOUNT_DIR/modules \
    $MOUNT_DIR/proc $MOUNT_DIR/sbin $MOUNT_DIR/sys $MOUNT_DIR/usr/bin \
    $MOUNT_DIR/usr/sbin $MOUNT_DIR/usr/local $MOUNT_DIR/var/log

    if [ ! $QUIET ]; then 
        echo "= Copying files from source directories to ${MOUNT_DIR}"; fi
    # TODO change this to "for $x in `cat filelist.txt`"
    # TODO add the ubd block devices, so you can make devfs go away
    $CP $BASE/modules/busybox $MOUNT_DIR/bin
    $CP $BASE/modules/mini_httpd.cram $MOUNT_DIR/modules
    $CP $BASE/modules/lode-lat1u-16.psf.gz $MOUNT_DIR/etc
    $CP $ANT_CVS/scripts/rcS $MOUNT_DIR/etc/init.d
    $CP $ANT_CVS/scripts/ant_functions.sh $MOUNT_DIR/etc
    $CP $ANT_CVS/configs/inittab $MOUNT_DIR/etc
    $CP $ANT_CVS/scripts/dir.sh $MOUNT_DIR/bin
    $SYMLINK /bin/busybox $MOUNT_DIR/bin/sh
    $SYMLINK /bin/busybox $MOUNT_DIR/sbin/init
    $SYMLINK /bin/dir.sh $MOUNT_DIR/bin/dir 
    $TOUCH $MOUNT_DIR/etc/ld.so.conf
    $TOUCH $MOUNT_DIR/etc/fstab

    # copy in the correct modules package
    case "$IMAGETYPE" in
        "all")  $CP $BASE/modules/modules_all* $MOUNT_DIR/modules;;
        "net")  $CP $BASE/modules/modules_net* $MOUNT_DIR/modules;;
        "usb")  $CP $BASE/modules/modules_usb* $MOUNT_DIR/modules;;
    esac

    # do we need to create devices on the new image?
    if [ ! $NOMAKEDEVS ]; then
	    if [ ! $QUIET ]; then echo "= Creating devices on new ${MOUNT_DIR}"; fi
    	# a symlink for the kernel core
	    $SYMLINK /proc/kcore $MOUNT_DIR/dev/core
    	# and mknod for the rest of the devices
	    $MKNOD $MOUNT_DIR/dev/console c 5 1 
    	$MKNOD $MOUNT_DIR/dev/full c 1 7
	    $MKNOD $MOUNT_DIR/dev/loop0 b 7 0
       	$MKNOD $MOUNT_DIR/dev/initrd b 1 250
    	$MKNOD $MOUNT_DIR/dev/mem c 1 1
	    $MKNOD $MOUNT_DIR/dev/null c 1 3
    	$MKNOD $MOUNT_DIR/dev/port c 1 4
    	$MKNOD $MOUNT_DIR/dev/random c 1 8
    	$MKNOD $MOUNT_DIR/dev/ram1 b 1 1
    	# a link to /dev/ram
    	$SYMLINK /dev/ram1 $MOUNT_DIR/dev/ram
    	$MKNOD $MOUNT_DIR/dev/tty c 5 0
    	$MKNOD $MOUNT_DIR/dev/tty0 c 4 0
    	$MKNOD $MOUNT_DIR/dev/ttyS0 c 4 64
    	$MKNOD $MOUNT_DIR/dev/urandom c 1 9
        $MKNOD $MOUNT_DIR/dev/zero c 1 5
    fi # if [ ! $NOMAKEDEVS ]

    if [ ! $QUIET ]; then 
        echo "= Unmounting new initrd image from ${MOUNT_DIR}"; fi
    $UMOUNT $MOUNT_DIR

    # FIXME test using bzip instead of gzip for initrd images
    if [ ! $QUIET ]; then
        echo "= Gzipping initrd image to initrd.${IMAGETYPE}.${EPOCH}.gz"
    fi
    $GZIP -c -9 $OUTPUT_FILE > $BASE/initrd.$IMAGETYPE.$EPOCH.gz

    if [ ! $QUIET ]; then echo "= creating hardlink to newest initrd image"; fi
    if [ -f $BASE/initrd.$IMAGETYPE.gz ]; then
        $RM $BASE/initrd.$IMAGETYPE.gz
    fi
    $HARDLINK $BASE/initrd.$IMAGETYPE.$EPOCH.gz $BASE/initrd.$IMAGETYPE.gz

else # if [ $INITRD ]; then
    # mounting the image file as a vfat filesystem
    $MOUNT -t vfat -o loop $OUTPUT_FILE $MOUNT_DIR

    if [ ! $QUIET ]; then
        echo "= Copying floppy files to ${MOUNT_DIR}"; fi
    $CP $ANT_BASE/boot/vmlinuz $MOUNT_DIR/linux.vmz
    $CP $BASE/initrd.$IMAGETYPE.gz $MOUNT_DIR/initrd.gz
    $CP $ANT_CVS/configs/syslinux.cfg $MOUNT_DIR/
    # TODO make a copy of the below for the isolinux stanza above
    # generate the display file using the master makefile
    DISPLAY_TXT=modules_$IMAGETYPE BF_BASE=$BASE \
        $MAKE -f $ANTLINUX/Makefile display
    # copy it onto the floppy image
    $CP $BASE/display.txt $MOUNT_DIR/

    if [ ! $QUIET ]; then 
        echo "= Unmounting new floppy image from ${MOUNT_DIR}"; fi
    $UMOUNT $MOUNT_DIR

    if [ ! $QUIET ]; then echo "= creating hardlink to newest floppy image"; fi
    $RM $BASE/floppy.$IMAGETYPE.img
    $HARDLINK $BASE/floppy.$IMAGETYPE.$EPOCH.img $BASE/floppy.$IMAGETYPE.img
fi # # if [ $INITRD ]; then 

# remove the initrd image so another script doesn't have to deal with it
#echo "= Removing raw initrd image"
#$RM $BASE/initrd

echo "= Done!"
exit 0
