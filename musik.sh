#!/bin/bash

. $HOME/projects/scripts/functions

BUILD=musik
MUSIK_URL="http://hg.savannah.nongnu.org/hgweb/musik"
BUILD_DIR=${WORKING_DIR}/${BUILD}

echo "Building ${MUSIK_HOME} in ${BUILD_DIR}..."

(if [ ! -e $MUSIK_HOME ]; then
    cd `dirname $MUSIK_HOME`;
    hg clone ${MUSIK_URL};
    cd $MUSIK_HOME;
else
    cd $MUSIK_HOME;
    hg pull -u ${MUSIK_URL};
fi
./autogen.sh;
create_working_dir
chmod -R u+w ${BUILD_DIR}
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

CONFIG_OPTS="--prefix=$MUSIK_INSTALL ${CHOST_OPTION} --with-jdk-home=${MUSIK_JDK}"

cd ${BUILD_DIR} &&
$MUSIK_HOME/configure ${CONFIG_OPTS} &&
if test "x$1" = "xrelease"; then
    echo "Distchecking..."
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck && echo DONE;
else
    make all install && echo DONE
fi) 2>&1 | tee $MUSIK_HOME/errors
