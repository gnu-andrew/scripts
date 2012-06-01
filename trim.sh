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

if test "x$TRIM_DEBUG" = "xyes"; then
    DEBUG="--enable-debug";
fi

cd trim &&
$TRIM_HOME/configure --prefix=$TRIM_INSTALL $DEBUG &&
make all install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
