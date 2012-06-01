#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $XMMS_HOME ]; then
    cd `dirname $XMMS_HOME`;
    git clone git://xmmsroot2.git.sourceforge.net/gitroot/xmmsroot2/xmmsroot2 xmms;
    cd $XMMS_HOME;
fi

if test "x$XMMS_DEBUG" = "xyes"; then
    DEBUG="--enable-debug";
fi

./autogen.sh;
create_working_dir
rm -rf xmms
mkdir xmms
cd xmms &&
$XMMS_HOME/configure --prefix=$XMMS_INSTALL $DEBUG &&
make ${MAKE_OPTS} && 
make ${MAKE_OPTS} install &&
echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
