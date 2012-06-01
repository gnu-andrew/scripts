#!/bin/bash

. $HOME/projects/scripts/functions

(checkout_brandweg $BRANDWEG_DIR &&
./autogen.sh &&
create_working_dir &&
rm -rf brandweg &&
mkdir brandweg &&
cd brandweg &&
$BRANDWEG_HOME/configure --with-classpath-jar=$CLASSPATH_INSTALL/share/classpath/glibj.zip &&
make $MAKE_OPTS 2>&1 ${LOG_DIR}/$0.errors && echo COMPILED
