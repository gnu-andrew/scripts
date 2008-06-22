#!/bin/bash

. $HOME/projects/scripts/functions

# Hack to get around broken parallel build
MAKE_OPTS=

# Don't use Gentoo's dumb variable
JAVAC=

if test x$1 != "x"; then
    CP_HOME=${CLASSPATH_RELEASE_HOME};
    CP_REV="classpath-0_97-release-branch";
    BUILD_DIR=${WORKING_DIR}/classpath.release;
    INSTALL_DIR=${CLASSPATH_RELEASE_INSTALL};
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR} -type f -exec chmod 640 '{}' ';';
	find ${BUILD_DIR} -type d -exec chmod 750 '{}' ';';
    fi
else
    CP_HOME=${CLASSPATH_HOME};
    BUILD_DIR=${WORKING_DIR}/classpath;
    INSTALL_DIR=${CLASSPATH_INSTALL};
fi

if [ -e $CP_HOME ]; then
    cd $CP_HOME;
    cvs update -dP;
    make distclean;
else
    cd `dirname $CP_HOME`;
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/classpath co -r${CP_REV} classpath
    cd $CP_HOME;
fi
./autogen.sh &&
create_working_dir
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVA=$CACAO_INSTALL/bin/cacao \
${CP_HOME}/configure --prefix=${INSTALL_DIR} --enable-examples --enable-qt-peer \
    --enable-Werror --disable-plugin --with-ecj-jar=${ECJ_JAR} --enable-gstreamer-peer \
    --with-gjdoc --with-javah=javah --with-fastjar=/usr/bin/fastjar --disable-gjdoc 
if test x$1 != "x"; then
    make distcheck &> ${CP_HOME}/errors && echo DONE;
    #rm -rf $HOME/projects/httpdocs/classpath/doc;
    #mv ${BUILD_DIR}/doc/api/html $HOME/projects/httpdocs/classpath/doc; 
else
    make ${MAKE_OPTS} all install &> $CLASSPATH_HOME/errors && echo DONE;
fi



