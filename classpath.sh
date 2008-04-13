#!/bin/bash

. $HOME/projects/scripts/functions

# Configure to suit
CLASSPATH_HOME=$HOME/projects/classpath/classpath
ECJ_JAR=$HOME/bin/ecj.jar
VM=$HOME/build/cacao/bin/cacao

if [ -e $CLASSPATH_HOME ]; then
    cd $CLASSPATH_HOME;
    cvs update -dP;
    make distclean;
else
    cd `dirname $CLASSPATH_HOME`;
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/classpath co classpath
    cd $CLASSPATH_HOME;
fi
./autogen.sh &&
create_working_dir
rm -rf classpath &&
mkdir classpath &&
cd classpath &&
$CLASSPATH_HOME/configure --prefix=$CLASSPATH_INSTALL --enable-examples --enable-qt-peer \
    --enable-Werror --disable-plugin --with-ecj-jar=$ECJ_JAR --enable-gstreamer-peer \
    --with-vm=$VM --with-gjdoc
make $MAKE_OPTS all install &> $CLASSPATH_HOME/errors && echo DONE
#DISTCHECK_CONFIGURE_FLAGS="--disable-plugin" make distcheck &> $CLASSPATH_HOME/errors && echo DONE

