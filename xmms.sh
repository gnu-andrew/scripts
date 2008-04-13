#!/bin/bash

. $HOME/projects/scripts/functions

XMMS_DIR=$HOME/projects/xmms
INSTALL_DIR=$HOME/build/xmms

if [ ! -e $XMMS_DIR ]; then
    cd `dirname $XMMS_DIR`;
    svn co https://xmmsroot2.svn.sourceforge.net/svnroot/xmmsroot2/xmms/trunk xmms;
fi
cd $XMMS_DIR;
./autogen.sh;
create_working_dir
rm -rf xmms
mkdir xmms
cd xmms
$XMMS_DIR/configure --prefix=$INSTALL_DIR
make all install &> $XMMS_DIR/errors && echo DONE
 
