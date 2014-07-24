#!/bin/bash

. $HOME/projects/scripts/functions

BUILD=icedtea-sound
ICEDTEA_SOUND_URL="http://icedtea.classpath.org/hg"
BUILD_DIR=${WORKING_DIR}/${BUILD}

if test "x${RELEASE}" != "x"; then
  ICEDTEA_SOUND_HOME=${ICEDTEA_SOUND_HOME}-${RELEASE}
  ICEDTEA_SOUND_URL=${ICEDTEA_SOUND_URL}/release/icedtea-sound-${RELEASE}
else
  ICEDTEA_SOUND_URL=${ICEDTEA_SOUND_URL}/icedtea-sound
fi

echo "Building ${ICEDTEA_SOUND_HOME} in ${BUILD_DIR}..."

(if [ ! -e $ICEDTEA_SOUND_HOME ]; then
    cd `dirname $ICEDTEA_SOUND_HOME`;
    hg clone ${ICEDTEA_SOUND_URL};
    cd $ICEDTEA_SOUND_HOME;
else
    cd $ICEDTEA_SOUND_HOME;
    hg pull -u;
fi
./autogen.sh;
create_working_dir
chmod -R u+w ${BUILD_DIR}
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

CONFIG_OPTS="--prefix=$ICEDTEA_SOUND_INSTALL ${CHOST_OPTION} --with-jdk-home=${ICEDTEA_SOUND_JDK}"

cd ${BUILD_DIR} &&
$ICEDTEA_SOUND_HOME/configure ${CONFIG_OPTS} &&
if test "x$1" = "xrelease"; then
    echo "Distchecking..."
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck && echo DONE;
else
    make ${MAKE_OPTS} all && make ${MAKE_OPTS} install && echo DONE
fi) 2>&1 | tee ${LOG_DIR}/$0.errors
