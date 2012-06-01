#!/bin/bash

. $HOME/projects/scripts/functions

if [ $(echo $0|grep 'icedtea-web-1.0') ]; then
    BUILD=icedtea-web-1.0
    RELEASE="1.0"
else
    BUILD=icedtea-web
fi

ICEDTEA_WEB_URL="http://icedtea.classpath.org/hg"
BUILD_DIR=${WORKING_DIR}/${BUILD}

if test "x${RELEASE}" != "x"; then
  ICEDTEA_WEB_HOME=${ICEDTEA_WEB_HOME}-${RELEASE}
  ICEDTEA_WEB_URL=${ICEDTEA_WEB_URL}/release/icedtea-web-${RELEASE}
else
  ICEDTEA_WEB_URL=${ICEDTEA_WEB_URL}/icedtea-web
fi

echo "Building ${ICEDTEA_WEB_HOME} in ${BUILD_DIR}..."

(if [ ! -e $ICEDTEA_WEB_HOME ]; then
    cd `dirname $ICEDTEA_WEB_HOME`;
    hg clone ${ICEDTEA_WEB_URL};
    cd $ICEDTEA_WEB_HOME;
else
    cd $ICEDTEA_WEB_HOME;
    hg pull -u;
fi
./autogen.sh;
create_working_dir
chmod -R u+w ${BUILD_DIR}
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

CONFIG_OPTS="--prefix=$ICEDTEA_WEB_INSTALL ${CHOST_OPTION} --with-jdk-home=${ICEDTEA_WEB_JDK}"

cd ${BUILD_DIR} &&
$ICEDTEA_WEB_HOME/configure ${CONFIG_OPTS} &&
if test "x$1" = "xrelease"; then
    echo "Distchecking..."
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck && echo DONE;
else
    make all install && echo DONE
fi) 2>&1 | tee ${LOG_DIR}/$0.errors
