#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e ${WATCHMAN_HOME} ]; then
    cd `dirname $WATCHMAN_HOME`;
    git clone https://github.com/facebook/watchman.git ${WATCHMAN_HOME}
    cd ${WATCHMAN_HOME}
    git checkout v${WATCHMAN_VERSION}
fi

rm -rf $WATCHMAN_INSTALL
cd $WATCHMAN_HOME
./autogen.sh;
create_working_dir
rm -rf watchman
mkdir watchman
cd watchman &&
$WATCHMAN_HOME/configure --prefix=$WATCHMAN_INSTALL &&
make ${MAKE_OPTS} &&
make ${MAKE_OPTS} install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
