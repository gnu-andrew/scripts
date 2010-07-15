#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $AZTOOLS_HOME ]; then
    cd `dirname $AZTOOLS_HOME`;
    hg clone ssh://ahughes@to-openjdk1.usersys.redhat.com//opt/hg/azulmri/hg/aztools;
    cd $AZTOOLS_HOME;
else
    cd $AZTOOLS_HOME;
    hg pull -u;
fi
./autogen.sh;
create_working_dir
rm -rf aztools
mkdir aztools

cd aztools &&
$AZTOOLS_HOME/configure --prefix=$AZTOOLS_INSTALL &&
make all install && echo DONE) 2>&1 | tee $AZTOOLS_HOME/errors
