#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $ARCHIVER_HOME ]; then
    cd `dirname $ARCHIVER_HOME`;
    hg clone http://fuseyism.com/hg/mail-archiver;
    cd $ARCHIVER_HOME;
else
    cd $ARCHIVER_HOME;
    hg pull -u;
fi
./autogen.sh;
create_working_dir
rm -rf archiver
mkdir archiver
cd archiver &&
$ARCHIVER_HOME/configure --prefix=$ARCHIVER_INSTALL &&
make all install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
