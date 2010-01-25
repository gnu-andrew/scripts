#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $TRIM_HOME ]; then
    cd `dirname $TRIM_HOME`;
    hg clone http://fuseyism.com/hg/trim;
    cd $TRIM_HOME;
else
    cd $TRIM_HOME;
    hg pull -u;
fi
./autogen.sh;
create_working_dir
rm -rf trim
mkdir trim
cd trim &&
$TRIM_HOME/configure --prefix=$TRIM_INSTALL &&
make all install && echo DONE) 2>&1 | tee $TRIM_HOME/errors
