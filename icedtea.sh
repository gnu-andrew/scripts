#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

BUILD_DIR=${WORKING_DIR}/icedtea

if test x$1 != "x"; then
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR} -type f -exec chmod 640 '{}' ';';
	find ${BUILD_DIR} -type d -exec chmod 750 '{}' ';';
	rm -rf ${BUILD_DIR};
	mkdir ${BUILD_DIR};
    fi
fi

if [ -e $ICEDTEA_HOME ]; then
    cd $ICEDTEA_HOME;
    hg pull -u;
    make distclean;
else
    cd `dirname $ICEDTEA_HOME`;
    hg clone http://icedtea.classpath.org/hg/icedtea;
    cd $ICEDTEA_HOME;
fi

CONFIG_OPTS="--with-parallel-jobs=9 --with-libgcj-jar=/usr/lib/jvm/gcj-jdk-4.3/jre/lib/rt.jar \
    --with-gcj-home=/usr/lib/jvm/gcj-jdk-4.3 --with-openjdk-src-zip=${OPENJDK_ZIP}"

cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test x$1 != "x"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck;
else
    make &> $ICEDTEA_HOME/errors && echo DONE;
fi
