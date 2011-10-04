#!/bin/bash

. $HOME/projects/scripts/functions

if [ -e $JAMVM_HOME ]; then
    cd $JAMVM_HOME;
    make distclean;
    git pull origin master;
else
    cd `dirname $JAMVM_HOME`;
    #cvs -z3 -d:pserver:anonymous@cvs.jamvm.berlios.de:/cvsroot/jamvm co jamvm;
    git clone git://git.berlios.de/jamvm
    cd $JAMVM_HOME;
fi
./autogen.sh --help
create_working_dir
(rm -rf jamvm &&
mkdir jamvm &&
cd jamvm &&
$JAMVM_HOME/configure --with-classpath-install-dir=$CLASSPATH_INSTALL --prefix=$JAMVM_INSTALL
make $MAKE_OPTS && make install && echo DONE ) 2>&1 | tee $JAMVM_HOME/errors 

