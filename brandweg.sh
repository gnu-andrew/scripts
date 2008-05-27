#!/bin/bash

. functions

BUILD_DIR=$WORKING_DIR/brandweg

checkout_brandweg $BRANDWEG_DIR
./autogen.sh
cd $BUILD_DIR
$BRANDWEG_DIR/configure --with-classpath-jar=$CLASSPATH_INSTALL/share/classpath/glibj.zip
make $MAKE_OPTS &> errors && echo COMPILED
