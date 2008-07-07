#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

VERCHECK=$(echo $0|grep 'icedtea6')
if [ $VERCHECK ]; then
    VERSION=icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
else
    VERSION=icedtea;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
fi

BUILD_DIR=${WORKING_DIR}/${VERSION}
ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}

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
    hg clone http://icedtea.classpath.org/hg/${VERSION};
    cd $ICEDTEA_HOME;
fi
autoreconf

if test x${OPENJDK_ZIP} != "x"; then
    ZIP_OPTION="--with-openjdk-src-zip=${OPENJDK_ZIP}";
fi

if test x${ICEDTEA_WITH_CACAO} = "xyes"; then
    CACAO_OPTION="--with-cacao";
fi

CONFIG_OPTS="--with-parallel-jobs=${PARALLEL_JOBS} --with-libgcj-jar=/usr/lib/jvm/gcj-jdk-4.3/jre/lib/rt.jar \
    --with-gcj-home=/usr/lib/jvm/gcj-jdk-4.3 ${ZIP_OPTION} --without-rhino ${CACAO_OPTION}"

cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck &> $ICEDTEA_HOME/errors;
else
    make &> $ICEDTEA_HOME/errors && echo DONE;
fi
