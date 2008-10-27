#!/bin/bash

. $HOME/projects/scripts/functions

if [ ! -e $DVBTOOLS_HOME ]; then
    cd `dirname $DVBTOOLS_HOME`;
    hg clone http://fuseyism.com/hg/dvbtools
    cd $DVBTOOLS_HOME;
else
    cd $DVBTOOLS_HOME;
    hg pull -u;
fi
./autogen.sh
create_working_dir
rm -rf dvbtools
mkdir dvbtools
cd dvbtools
$DVBTOOLS_HOME/configure --prefix=$DVBTOOLS_INSTALL
(make ${MAKE_OPTS} all check install && echo DONE) 2>&1 | tee $DVBTOOLS_HOME/errors

 