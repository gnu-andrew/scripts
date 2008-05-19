#!/bin/bash

. $HOME/projects/scripts/environment
. $HOME/projects/scripts/functions

# Hack to get around broken parallel build
MAKE_OPTS=

# Don't use Gentoo's dumb variable
JAVAC=

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
    --with-vm=$VM --with-gjdoc --with-javah=javah --with-fastjar=/usr/bin/fastjar
make $MAKE_OPTS all install &> $CLASSPATH_HOME/errors && echo DONE
#DISTCHECK_CONFIGURE_FLAGS="--disable-plugin" make distcheck &> $CLASSPATH_HOME/errors && echo DONE

