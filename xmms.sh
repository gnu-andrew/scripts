#!/bin/bash

. $HOME/projects/scripts/functions

if [ ! -e $XMMS_HOME ]; then
    cd `dirname $XMMS_HOME`;
    svn co https://xmmsroot2.svn.sourceforge.net/svnroot/xmmsroot2/xmms/trunk xmms;
fi
cd $XMMS_HOME;
./autogen.sh;
create_working_dir
rm -rf xmms
mkdir xmms
cd xmms
$XMMS_HOME/configure --prefix=$XMMS_INSTALL --disable-flac
make all install &> $XMMS_HOME/errors && echo DONE
 
