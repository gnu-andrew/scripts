#!/bin/bash

. $HOME/projects/scripts/functions

# Hack to get around broken parallel build
MAKE_OPTS=

# Don't use Gentoo's dumb variable
JAVAC=

BUILD_DIR=${WORKING_DIR}/cp-tools

if [ -e $CLASSPATH_TOOLS_HOME ]; then
    cd $CLASSPATH_TOOLS_HOME;
    cvs update -dP;
    make distclean;
else
    cd `dirname $CP_HOME`;
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/classpath co cp-tools
    cd $CLASSPATH_TOOLS_HOME;
fi
./autogen.sh &&
create_working_dir
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVA=$VM \
${CLASSPATH_TOOLS_HOME}/configure --prefix=${CLASSPATH_TOOLS_INSTALL} --without-gnu-bytecode 
make ${MAKE_OPTS} all install &> $CLASSPATH_TOOLS_HOME/errors && echo DONE;



