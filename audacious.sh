#!/bin/bash

. $HOME/projects/scripts/functions

(if [ ! -e $AUDACIOUS_HOME ]; then
    cd `dirname $AUDACIOUS_HOME`;
    git clone git://git.atheme.org/audacious.git $AUDACIOUS_HOME
fi

rm -rf $AUDACIOUS_INSTALL
cd $AUDACIOUS_HOME
./autogen.sh;
create_working_dir
rm -rf audacious
mkdir audacious
(cd audacious &&
${AUDACIOUS_HOME}/configure --prefix=$AUDACIOUS_INSTALL &&
make ${MAKE_OPTS} && 
make ${MAKE_OPTS} install &&
echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
