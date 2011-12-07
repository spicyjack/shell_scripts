#!/bin/bash

# script variables
CFG_PKG="icinga"
CFG_DIR=/opt/${CFG_PKG}
ICINGA_BUILD_DIR="/usr/local/src/icinga"
SF_BASE="http://sourceforge.net/projects/icinga/files"

### SCRIPT FUNCTIONS ###
show_banner () {
    show_banner_TEXT="$*"
    echo "############# ${show_banner_TEXT} #############"
} # show_banner

### BEGIN MAIN SCRIPT ###

## PREREQS FUNCTION ##
prereqs () {
    # create an icinga user
    # /usr/sbin/adduser --gid XXX --uid XXX --home XXX --disabled-login icinga
    show_banner "Adding 'icinga' user"
    /usr/sbin/useradd --system --create-home icinga

    # install prerequisites
    show_banner "Installing prerequisite packages"
    apt-get --assume-yes install apache2 build-essential libgd2-xpm-dev \
        libjpeg62 libjpeg62-dev libpng12-0 libpng12-dev snmp libsnmp-base \
        libdbi0 libdbi0-dev libssl-dev mysql-client libperl-dev

    # create and change to the build directory
    show_banner "Creating build directory"
    mkdir -p $ICINGA_BUILD_DIR
    cd ${ICINGA_BUILD_DIR}
} # prereqs

## INSTALL_ICINGA FUNCTION ##
install_icinga () {
    # icinga
    local VERSION="1.6.1"
    local START_DIR=$PWD

    if [ ! -e "icinga-${VERSION}.tar.gz" ]; then
        show_banner "Dowloading icinga version $VERSION"
        wget -O icinga-${VERSION}.tar.gz \
        ${SF_BASE}/icinga/${VERSION}/icinga-${VERSION}.tar.gz/download
    fi
    if [ -d "icinga-${VERSION}" ]; then
        show_banner "Removing old copy of icinga"
        rm -rf "icinga-${VERSION}"
    fi
    show_banner "Unpacking icinga version ${VERSION}"
    tar -zxvf icinga-${VERSION}.tar.gz

    cd icinga-${VERSION}
    show_banner "Running './configure'"
    ./configure --prefix=/usr/local/share/icinga --enable-idoutils \
    --enable-nanosleep --enable-ssl --with-perlcache --enable-embedded-perl
    show_banner "Running 'make all'"
    /usr/bin/time make all
    show_banner "Running 'make install'"
    /usr/bin/time make install
    show_banner "Running 'make install-idoutils'"
    /usr/bin/time make install-idoutils
    show_banner "Running 'make install-config'"
    /usr/bin/time make install-config
    show_banner "Running 'make install-webconf'"
    /usr/bin/time make install-webconf
    # FIXME move the resulting file from /etc/apache2/conf.d to
    # /etc/apache2/sites-available
    show_banner "Moving config file to sites-available"
    if [ ! -e /etc/apache2/sites-available/icinga ]; then
        /bin/mv /etc/apache2/conf.d/icinga.conf \
            /etc/apache2/sites-available/icinga
    else
        echo "WARNING: /etc/apache2/sites-available/icinga file exists"
        echo "WARNING: Will not replace existing file"
        echo "WARNING: Copy the file /etc/apache2/conf.d/icinga.conf"
        echo "WARNING: to /etc/apache2/sites-available/icinga if you"
        echo "WARNING: want to use the default Icinga Apache config file"
    fi

    # from apache2.2-common
    show_banner "Enabling icinga site via sites-enabled/a2ensite"
    /usr/sbin/a2ensite icinga
    cd ..


    # icinga-web
    VERSION=1.6.0
    if [ ! -e "icinga-web-${VERSION}.tar.gz" ]; then
        wget -O icinga-web-${VERSION}.tar.gz \
        ${SF_BASE}/icinga-web/${VERSION}/icinga-web-${VERSION}.tar.gz/download
    fi
    if [ -d "icinga-web-${VERSION}" ]; then
        rm -rf "icinga-web-${VERSION}"
    fi
    tar -zxvf icinga-web-${VERSION}.tar.gz

    # icinga-reports
    VERSION=1.6.0
    if [ ! -e "icinga-reports-${VERSION}.tar.gz" ]; then
        wget -O icinga-reports-${VERSION}.tar.gz \
            ${SF_BASE}/icinga-reporting/${VERSION}/icinga-reports-${VERSION}.tar.gz/download
    fi
    if [ -d "icinga-reports-${VERSION}" ]; then
        rm -rf "icinga-reports-${VERSION}"
    fi
    tar -zxvf icinga-reports-${VERSION}.tar.gz

    # icinga-mobile
    VERSION=0.1.0
    if [ ! -e "icinga-mobile-${VERSION}.zip" ]; then
        wget -O icinga-mobile-${VERSION}.zip \
        ${SF_BASE}/icinga-mobile/${VERSION}/icinga-mobile-${VERSION}.zip/download
    fi
    if [ -d "icinga-mobile-${VERSION}" ]; then
        rm -rf "icinga-mobile-${VERSION}"
    fi
    unzip icinga-mobile-${VERSION}.zip



# make the directory if it doesn't exist
if [ -d $CFG_DIR ]; then
  mkdir -p $CFG_DIR
fi

#mount -t ext4 /dev/sdj1 $CFG_DIR

# move the existing nagios config out of the way
mv /etc/${CFG_PKG} /etc/${CFG_PKG}.orig
ln -s /opt/${CFG_PKG}/config /etc/${CFG_PKG}
mv /usr/share/${CFG_PKG} /usr/share/${CFG_PKG}.orig
ln -s /opt/${CFG_PKG}/share /usr/share/${CFG_PKG}
mv /usr/lib/cgi-bin/ /usr/lib/cgi-bin/${CFG_PKG}
ln -s /opt/${CFG_PKG}/cgi-bin /usr/lib/cgi-bin/${CFG_PKG}

# restart nagios with the new config
/etc/init.d/${CFG_PKG} stop; sleep 2; /etc/init.d/${CFG_PKG} start

exit 0

# vim: set shiftwidth=4 tabstop=4
