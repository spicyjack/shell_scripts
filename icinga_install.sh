#!/bin/sh

# script variables
CFG_PKG="icinga"
CFG_DIR=/opt/${CFG_PKG}
ICINGA_BUILD_DIR="/usr/local/src/icinga"
SF_BASE="http://sourceforge.net/projects/icinga/files"

    # create an icinga user
    # /usr/sbin/adduser --gid XXX --uid XXX --home XXX --disabled-login icinga
    /usr/sbin/useradd --system --create-home icinga

    # install prerequisites
    apt-get --assume-yes install apache2 build-essential libgd2-xpm-dev \
        libjpeg62 libjpeg62-dev libpng12-0 libpng12-dev snmp libsnmp-base \
        libdbi0 libdbi0-dev libssl-dev mysql-client

    # create and change to the build directory
    mkdir -p $ICINGA_BUILD_DIR
    cd ${ICINGA_BUILD_DIR}

    # icinga
    VERSION=1.6.1
    if [ ! -e "icinga-${VERSION}.tar.gz" ]; then
        wget -O icinga-${VERSION}.tar.gz \
        ${SF_BASE}/icinga/${VERSION}/icinga-${VERSION}.tar.gz/download
    fi
    if [ -d "icinga-${VERSION}" ]; then
        rm -rf "icinga-${VERSION}"
    fi
    tar -zxvf icinga-${VERSION}.tar.gz
    cd icinga-${VERSION}
    ./configure --prefix=/usr/local/share/icinga --enable-idoutils \
    --enable-nanosleep --enable-ssl --with-perlcache --enable-embedded-perl
    time make all
    cd ..
exit 0
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
