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
    BUILD=icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
elif [ $(echo $0|grep 'cvmi') ]; then
    VERSION=icedtea;
    BUILD=cvmi;
    OPENJDK_DIR=$CVMI_DIR;
else
    VERSION=icedtea;
    BUILD=icedtea;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
fi

BUILD_DIR=${WORKING_DIR}/${BUILD}
ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}

echo "Building ${VERSION} in ${BUILD_DIR}..."

if test x$1 != "x"; then
    echo "Building from scratch"
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR}/${BUILD}-* -type f -exec chmod 640 '{}' ';' \
	    -o -type d -exec chmod 750 '{}' ';';
	rm -rf ${BUILD_DIR};
    fi
    mkdir ${BUILD_DIR};
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
./autogen.sh

if test x${OPENJDK_ZIP} != "x"; then
    ZIP_OPTION="--with-openjdk-src-zip=${OPENJDK_ZIP}";
fi

if test x${OPENJDK_DIR} != "x"; then
    DIR_OPTION="--with-openjdk-src-dir=${OPENJDK_DIR}";
fi

if test x${ICEDTEA_WITH_CACAO} = "xyes"; then
    CACAO_OPTION="--with-cacao";
fi

if test x${ICEDTEA_WITH_SHARK} = "xyes"; then
    SHARK_OPTION="--enable-shark";
fi

RT_JAR=${CLASSPATH_INSTALL}/share/classpath/glibj.zip

CONFIG_OPTS="--with-parallel-jobs=${PARALLEL_JOBS} --with-libgcj-jar=${RT_JAR} \
    --with-gcj-home=/usr/lib/jvm/gcj-jdk ${ZIP_OPTION} ${DIR_OPTION} --without-rhino \
    --disable-docs ${CACAO_OPTION}"

cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck &> $ICEDTEA_HOME/errors;
else
    (make && echo DONE) 2>&1 | tee $ICEDTEA_HOME/errors
fi
