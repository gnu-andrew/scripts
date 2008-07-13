#!/bin/bash

. $HOME/projects/scripts/functions

if [ ! -e $XMMS_HOME ]; then
    cd `dirname $XMMS_HOME`;
    svn co https://xmmsroot2.svn.sourceforge.net/svnroot/xmmsroot2/xmms/trunk xmms;
    cd $XMMS_HOME;
else
    cd $XMMS_HOME;
    svn update;
fi
./autogen.sh;
create_working_dir
rm -rf xmms
mkdir xmms
cd xmms
$XMMS_HOME/configure --prefix=$XMMS_INSTALL
(make all install &> $XMMS_HOME/errors && echo DONE) &
tail -f $XMMS_HOME/errors

 
