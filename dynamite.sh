#!/bin/bash

. $HOME/projects/scripts/functions

if [ ! -e $DYNAMITE_HOME ]; then
    cd `dirname $DYNAMITE_HOME`;
    git clone git://git.savannah.nongnu.org/dynamite.git dynamite
    cd $DYNAMITE_HOME;
else
    cd $DYNAMITE_HOME;
    #git pull;
fi
./autogen.sh;
create_working_dir
rm -rf dynamite
mkdir dynamite
(cd dynamite &&
$DYNAMITE_HOME/configure --prefix=$DYNAMITE_INSTALL --with-debug-level=CONFIG &&
make all install && echo DONE) 2>&1 | tee $DYNAMITE_HOME/errors

 
