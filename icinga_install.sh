#!/bin/bash

# docs
# http://docs.icinga.org/latest/en/

# TODO
# - create debian package scripts for icinga
# - use the MD5 sum posted on sourceforge to validate the download binary

# Icinga versions
# icinga-db comes in icinga-core
ICINGA_CORE_VERSION="1.7.1"
ICINGA_WEB_VERSION="1.7.1"

# script variables
ICINGA_BUILD_DIR="/usr/local/src/icinga"
ICINGA_INSTALL_DIR="/usr/local/stow"
ICINGA_BASE_URL="http://sourceforge.net/projects/icinga/files"

### SCRIPT FUNCTIONS ###
show_banner () {
    show_banner_text="$*"
    echo "############# ${show_banner_text} #############"
} # show_banner

### BEGIN MAIN SCRIPT ###

## PREREQS FUNCTION ##
build_prereqs () {
    # create an icinga user
    # /usr/sbin/adduser --gid XXX --uid XXX --home XXX --disabled-login icinga
    ICINGA_USER_STATUS=$(id icinga)
    # does the icinga user already exist?
    if [ $ICINGA_USER_STATUS -gt 0 ];
        show_banner "Adding 'icinga' group"
        /usr/bin/groupadd --gid 424
        show_banner "Adding 'icinga' user"
        /usr/sbin/useradd --system --gid 424 --uid 424 \
            --home /var/lib/icinga --comment "Icinga User" \
            --create-home icinga
    fi

    # create and change to the build directory
    show_banner "Creating build directory"
    mkdir -p $ICINGA_BUILD_DIR
    cd ${ICINGA_BUILD_DIR}
} # prereqs

# get a list of packages to test against with:
# dpkg -l | tail -n +6 | awk '{print $2}'
check_pkg_prereqs () {
    REQUIRED_PACKAGES="apache2 apache2-mpm-prefork build-essential
        libgd2-xpm libgd2-xpm-dev libjpeg62 libjpeg62-dev libpng12-0
        libpng12-dev snmp libsnmp-base libdbi0 libdbi0-dev libssl-dev
        mysql-client libperl-dev
    " # REQUIRED_PACKAGES

    INSTALLED_PACKAGES=$(dpkg -l | tail -n +6 | awk '{print $2}')
    REQUIRED_PACKAGES_FLAG=1

    for PKG in $(echo ${REQUIRED_PACKAGES});
    do
        if [ $(echo ${INSTALLED_PACKAGES} | grep -c ${PKG}) -eq 0 ]; then
            echo "Missing package: ${PKG}"
            REQUIRED_PACKAGES_FLAG=0
        fi
    done
    if [ $REQUIRED_PACKAGES_FLAG -eq 0 ]; then
        echo "Please install the above missing packages and then"
        echo "re-run this installer"
        exit 1
    fi
}

## INSTALL_ICINGA ##
install_icinga_core () {
    local PKG="icinga"
    local VERSION=${ICINGA_CORE_VERSION}

    # install prerequisites
    #show_banner "Installing prerequisite packages for ${PKG}-${VERSION}"
    # FIXME check for prerequisites before continuing

    if [ ! -e "${PKG}-${VERSION}.tar.gz" ]; then
        show_banner "Dowloading ${PKG} version ${ICINGA_VERSION}"
        show_banner "to ${ICINGA_BUILD_DIR}"
        wget -O $ICINGA_BUILD_DIR/${PKG}-${ICINGA_CORE_VERSION}.tar.gz \
        ${SF_BASE}/${PKG}/${VERSION}/${PKG}-${ICINGA_CORE_VERSION}.tar.gz/download
    fi
    if [ -d "${PKG}-${ICINGA_CORE_VERSION}" ]; then
        show_banner "Removing old copy of ${PKG}-${ICINGA_CORE_VERSION}"
        rm -rf "${PKG}-${ICINGA_CORE_VERSION}"
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
    show_banner "Copying idoutils config and modules files from samples"
    /bin/cp /usr/local/icinga/icinga-core/etc/ido2db.cfg-sample \
        /usr/local/icinga/icinga-core/etc/ido2db.cfg
    /bin/cp /usr/local/icinga/icinga-core/etc/idomod.cfg-sample \
        /usr/local/icinga/icinga-core/etc/idomod.cfg
    /bin/cp /usr/local/icinga/icinga-core/etc/modules/idoutils.cfg-sample \
        /usr/local/icinga/icinga-core/etc/modules/idoutils.cfg
    show_banner "Running 'make install-config'"
    /usr/bin/time make install-config
    show_banner "Running 'make install-webconf'"
    /usr/bin/time make install-webconf
    show_banner "Running 'make install-init'"
    /usr/bin/time make install-init
    show_banner "Running 'make install-commandmode'"
    /usr/bin/time make install-commandmode
    #show_banner "Running 'make install-dev-docu'"
    #/usr/bin/time make install-dev-docu
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

    # restart icinga
    if [ -e /etc/init.d/icinga ]; then
        show_banner "Restarting ${PKG}-core"
        /etc/init.d/icinga restart
    fi

    # create an htpasswd file
    if [ ! -e /usr/local/icinga/icinga-core/etc/htpasswd.users ]; then
        show_banner "Creating top-level htpasswd file for icinga-core"
        /usr/bin/htpasswd -b -c $ICINGA_HTPASS_FILE icingaadmin t3mb00
        /usr/bin/htpasswd -b $ICINGA_HTPASS_FILE temboo t3mb00
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
    # FIXME this needs to be run by hand for now
    #make db-initialize
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

    # install prerequisites
    show_banner "Installing prerequisite packages for ${PKG}-core"
    apt-get --assume-yes install autoconf

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
    #cd ${PKG}-$VERSION
    cd ${PKG}
    #
    show_banner "Generating './configure' for ${PKG}"
    autoconf
    show_banner "Running './configure' for ${PKG}"
    ./configure \
        --with-web-user=www-data \
        --with-web-group=www-data \
        --with-web-apache-path=/etc/apache2 \
        --prefix=/usr/local/icinga/icinga-mobile
    #
    show_banner "Running 'make install'"
    make install
    show_banner "Running 'make install-apache-config'"
    make install-apache-config
    #show_banner "Running 'make install-javascript'"
    #make install-javascript
    show_banner "Moving config file to sites-available"
    if [ ! -e /etc/apache2/sites-available/${PKG} ]; then
        /bin/mv /etc/apache2/conf.d/${PKG}.conf \
            /etc/apache2/sites-available/${PKG}
    else
        echo "WARNING: /etc/apache2/sites-available/${PKG}-core file exists"
        echo "WARNING: Will not replace existing file"
        echo "WARNING: Copy the file /etc/apache2/conf.d/icinga.conf"
        echo "WARNING: to /etc/apache2/sites-available/${PKG}-core if you"
        echo "WARNING: want to use the default icinga Apache config file"
    fi

} # install_icinga_mobile


## MAIN SCRIPT ##
prereqs
install_icinga_core
install_icinga_web
install_icinga_mobile
#install_icinga_reports
exit 0

# make the directory for the configuration EBS volume if it doesn't exist
#if [ -d $CFG_DIR ]; then
#  mkdir -p $CFG_DIR
#fi
#mount -t ext4 /dev/sdj1 $CFG_DIR

# move the existing nagios config out of the way so the config files on the
# EBS volume can be used instead
#mv /etc/${CFG_PKG} /etc/${CFG_PKG}.orig
#ln -s /opt/${CFG_PKG}/config /etc/${CFG_PKG}
#mv /usr/share/${CFG_PKG} /usr/share/${CFG_PKG}.orig
#ln -s /opt/${CFG_PKG}/share /usr/share/${CFG_PKG}
#mv /usr/lib/cgi-bin/ /usr/lib/cgi-bin/${CFG_PKG}
#ln -s /opt/${CFG_PKG}/cgi-bin /usr/lib/cgi-bin/${CFG_PKG}

# restart nagios with the new config
#/etc/init.d/${CFG_PKG} stop; sleep 2; /etc/init.d/${CFG_PKG} start

exit 0

# vim: set shiftwidth=4 tabstop=4
