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



    # create and change to the build directory
    show_banner "Creating build directory"
    mkdir -p $ICINGA_BUILD_DIR
    cd ${ICINGA_BUILD_DIR}
} # prereqs

## INSTALL_ICINGA ##
install_icinga_core () {
    local VERSION="1.6.1"
    local START_DIR=$PWD
    local PKG="icinga"

    # install prerequisites
    show_banner "Installing prerequisite packages for ${PKG}-core"
    apt-get --assume-yes install apache2 build-essential libgd2-xpm-dev \
        libjpeg62 libjpeg62-dev libpng12-0 libpng12-dev snmp libsnmp-base \
        libdbi0 libdbi0-dev libssl-dev mysql-client libperl-dev

    if [ ! -e "${PKG}-${VERSION}.tar.gz" ]; then
        show_banner "Dowloading ${PKG}-core version $VERSION"
        wget -O ${PKG}-${VERSION}.tar.gz \
        ${SF_BASE}/${PKG}/${VERSION}/${PKG}-${VERSION}.tar.gz/download
    fi
    if [ -d "${PKG}-${VERSION}" ]; then
        show_banner "Removing old copy of ${PKG}-core"
        rm -rf "${PKG}-${VERSION}"
    fi
    show_banner "Unpacking ${PKG}-core version ${VERSION}"
    tar -zxvf ${PKG}-${VERSION}.tar.gz

    cd ${PKG}-${VERSION}
    show_banner "Running './configure' for ${PKG}-core"
    ./configure --prefix=/usr/local/icinga/${PKG}-core --enable-idoutils \
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
    # move the resulting file from /etc/apache2/conf.d to
    # /etc/apache2/sites-available
    show_banner "Moving config file to sites-available"
    if [ ! -e /etc/apache2/sites-available/${PKG}-core ]; then
        /bin/mv /etc/apache2/conf.d/icinga.conf \
            /etc/apache2/sites-available/${PKG}-core
    else
        echo "WARNING: /etc/apache2/sites-available/${PKG}-core file exists"
        echo "WARNING: Will not replace existing file"
        echo "WARNING: Copy the file /etc/apache2/conf.d/icinga.conf"
        echo "WARNING: to /etc/apache2/sites-available/${PKG}-core if you"
        echo "WARNING: want to use the default icinga Apache config file"
    fi

    # from apache2.2-common
    show_banner "Enabling icinga site via sites-enabled/a2ensite"
    /usr/sbin/a2ensite ${PKG}-core
    cd $START_DIR
} # icinga-core

## INSTALL_ICINGA_WEB ##
install_icinga_web () {
    local VERSION=1.6.0
    local START_DIR=$PWD
    local PKG="icinga-web"

    # install prerequisites
    show_banner "Installing prerequisite packages for ${PKG}"
    apt-get --assume-yes install php5 php5-cli php-pear php5-xmlrpc \
        php5-xsl php5-gd php5-ldap php5-mysql
        #php5-xsl php5-pdo php5-soap php5-gd php5-ldap php5-mysql

    if [ ! -e "${PKG}-${VERSION}.tar.gz" ]; then
        show_banner "Downloading ${PKG} version ${VERSION}"
        wget -O ${PKG}-${VERSION}.tar.gz \
        ${SF_BASE}/${PKG}/${VERSION}/${PKG}-${VERSION}.tar.gz/download
    fi
    if [ -d "${PKG}-${VERSION}" ]; then
        show_banner "Removing old copy of ${PKG}"
        rm -rf "${PKG}-${VERSION}"
    fi
    #
    show_banner "Unpacking ${PKG} version ${VERSION}"
    tar -zxvf ${PKG}-${VERSION}.tar.gz
    cd ${PKG}-$VERSION
    #
    show_banner "Running './configure' for ${PKG}"
    ./configure --prefix=/usr/local/icinga/${PKG} \
                --with-web-user=www-data \
                --with-web-group=www-data \
                --with-web-path=/${PKG} \
                --with-web-apache-path=/etc/apache2/sites-available \
                --with-db-type=mysql \
                --with-db-host=localhost \
                --with-db-port=3306 \
                --with-db-name=icinga_web \
                --with-db-user=icinga_web \
                --with-db-pass=icinga_web \
                --with-conf-folder=etc/conf.d \
                --with-log-folder=log \
                --with-api-subtype=mysql \
                --with-api-host=localhost \
                --with-api-port=3306 \
                --with-api-socket="/var/run/mysqld/mysqld.sock"
    show_banner "Running 'make install'"
    make install
    show_banner "Running 'make install-apache-config'"
    make install-apache-config
    #show_banner "Running 'make install-javascript'"
    #make install-javascript
    show_banner "Moving config file to sites-available"
    if [ ! -e /etc/apache2/sites-available/${PKG} ]; then
        if [ -e /etc/apache2/sites-available/${PKG}.conf ]; then
            /bin/mv /etc/apache2/sites-available/${PKG}.conf \
                /etc/apache2/sites-available/${PKG}
        else
            echo "ERROR: /etc/apache2/sites-available/${PKG}.conf"
            echo "ERROR: not found; can't rename the config file"
        fi
    else
        echo "WARNING: /etc/apache2/sites-available/${PKG} exists"
        echo "WARNING: Will not replace existing file; Copy the file"
        echo "WARNING: /etc/apache2/sites-available/${PKG}.conf"
        echo "WARNING: to /etc/apache2/sites-available/${PKG}"
        echo "WARNING: to use the default ${PKG} config file"
    fi

    # from apache2.2-common
    show_banner "Enabling ${PKG} Apache config files via a2ensite"
    /usr/sbin/a2ensite ${PKG}
    cd $START_DIR
} # install_icinga_web

## ICINGA-REPORTS ##
install_icinga_reports () {
    local VERSION=1.6.0
    local START_DIR=$PWD
    local PKG="icinga-reports"

    # install prerequisites
    show_banner "Installing prerequisite packages for ${PKG}"
    apt-get --assume-yes install libjasperreports-java

    if [ ! -e "${PKG}-${VERSION}.tar.gz" ]; then
        show_banner "Downloading ${PKG} version ${VERSION}"
        wget -O ${PKG}-${VERSION}.tar.gz \
            ${SF_BASE}/icinga-reporting/${VERSION}/${PKG}-${VERSION}.tar.gz/download
    fi
    if [ -d "${PKG}-${VERSION}" ]; then
        show_banner "Removing old copy of ${PKG}"
        rm -rf "${PKG}-${VERSION}"
    fi
    #
    show_banner "Unpacking ${PKG} version ${VERSION}"
    tar -zxvf ${PKG}-${VERSION}.tar.gz
} # install_icinga_reports

## ICINGA MOBILE ##
install_icinga_mobile () {
    local START_DIR=$PWD
    local PKG="icinga-mobile"
    local VERSION=0.1.0

    if [ ! -e "${PKG}-${VERSION}.zip" ]; then
        show_banner "Downloading ${PKG} version ${VERSION}"
        wget -O ${PKG}-${VERSION}.zip \
        ${SF_BASE}/${PKG}/${VERSION}/${PKG}-${VERSION}.zip/download
    fi
    if [ -d "${PKG}-${VERSION}" ]; then
        show_banner "Removing old copy of ${PKG}"
        rm -rf "${PKG}-${VERSION}"
    fi
    #
    show_banner "Unpacking ${PKG} version ${VERSION}"
    unzip ${PKG}-${VERSION}.zip
    cd ${PKG}-$VERSION
    #
    show_banner "Running './configure' for ${PKG}"
    ./configure \
        --with-web-user=www-data \
        --with-web-group=www-data \
        --with-web-apache-path=/etc/apache2 \
        --prefix=/usr/local/icinga/icinga-mobile

} # install_icinga_mobile


## MAIN SCRIPT ##
prereqs
install_icinga_core
install_icinga_web
#install_icinga_reports
exit 0

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
