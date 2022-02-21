#!/bin/bash

. $HOME/projects/scripts/functions

BUILD=jigawatts
JIGAWATTS_WEB_HOME=jigawatts
JIGAWATTS_WEB_URL="https://github.com/chflood/jigawatts.git"
BUILD_DIR=${WORKING_DIR}/${BUILD}

echo "Building ${JIGAWATTS_HOME} in ${BUILD_DIR}..."

(if [ ! -e $JIGAWATTS_HOME ]; then
    cd `dirname $ICEDTEA_HOME`;
    git clone ${ICEDTEA_WEB_URL};
    cd $JIGAWATTS_HOME;
else
    cd $JIGAWATTS_HOME;
    git pull -v;
 fi
 echo "Running autogen.sh";
./autogen.sh;
create_working_dir
chmod -R u+w ${BUILD_DIR}
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

CONFIG_OPTS="--prefix=$JIGAWATTS_INSTALL --with-jdk-home=${JIGAWATTS_JDK}"

echo "Running configure...";
cd ${BUILD_DIR} &&
$JIGAWATTS_HOME/configure ${CONFIG_OPTS} && echo "Building jigawatts" &&
if test "x$1" = "xrelease"; then
    echo "Distchecking..."
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck && echo DONE;
else
    make all install && echo DONE
fi) 2>&1 | tee ${LOG_DIR}/$0.errors
