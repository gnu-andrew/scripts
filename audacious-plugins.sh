#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $AUDACIOUS_PLUGINS_HOME ]; then
    cd `dirname $AUDACIOUS_PLUGINS_HOME`;
    git clone git://git.atheme.org/audacious-plugins.git $AUDACIOUS_PLUGINS_HOME
fi

cd $AUDACIOUS_PLUGINS_HOME
./autogen.sh;
PKG_CONFIG_PATH=${AUDACIOUS_INSTALL}/lib/pkgconfig ./configure --prefix=$AUDACIOUS_INSTALL &&
make ${MAKE_OPTS} && 
make ${MAKE_OPTS} install &&
echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
