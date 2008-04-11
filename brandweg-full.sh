#!/bin/bash

# Configure to suit
BRANDWEG_DIR=$HOME/projects/classpath/brandweg

. functions

checkout_brandweg $BRANDWEG_DIR
./autogen.sh
create_working_dir
rm -rf brandweg
mkdir brandweg
cd brandweg
$BRANDWEG_DIR/configure --with-classpath-jar=$CLASSPATH_INSTALL/share/classpath/glibj.zip
make $MAKE_OPTS &> errors && echo COMPILED
