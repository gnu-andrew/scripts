#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

if [ ! -e $DYNAMITE_HOME ]; then
    cd `dirname $DYNAMITE_HOME`;
    git clone git://git.savannah.nongnu.org/dynamite.git dynamite
    cd $DYNAMITE_HOME;
else
    cd $DYNAMITE_HOME;
    git pull;
fi
./autogen.sh;
create_working_dir
rm -rf dynamite
mkdir dynamite
(cd dynamite &&
$DYNAMITE_HOME/configure --prefix=$DYNAMITE_INSTALL \
    --with-debug-level=$DYNAMITE_DEBUG_LEVEL --with-jdk-home=${CACAO_JDK_INSTALL} \
    --with-javadoc=${SYSTEM_ICEDTEA7}/bin/javadoc &&
make all install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors

