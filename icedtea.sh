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
    OPTS="--with-icedtea --with-project=${BUILD}";
elif [ $(echo $0|grep 'caciocavallo') ]; then
    VERSION=icedtea;
    BUILD=caciocavallo;
    OPTS="--with-icedtea --with-project=${BUILD}";
elif [ $(echo $0|grep 'closures') ]; then
    VERSION=icedtea;
    BUILD=closures;
    OPTS="--with-icedtea --with-project=${BUILD}";
else
    VERSION=icedtea;
    BUILD=icedtea;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPTS="";
fi

BUILD_DIR=${WORKING_DIR}/${BUILD}
ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}

echo "Building ${VERSION} in ${BUILD_DIR}..."

if test x$1 = "x"; then
    echo "Building from scratch"
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR}/${BUILD}-* -type f -exec chmod 640 '{}' ';' \
	    -o -type d -exec chmod 750 '{}' ';';
	rm -rf ${BUILD_DIR};
    fi
fi

if [ ! -e ${BUILD_DIR} ]; then
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
PATH=/bin:/usr/bin ./autogen.sh

if test x${OPENJDK_ZIP} != "x"; then
    ZIP_OPTION="--with-openjdk-src-zip=${OPENJDK_ZIP}";
fi

if test x${OPENJDK_DIR} != "x"; then
    DIR_OPTION="--with-openjdk-src-dir=${OPENJDK_DIR}";
fi

if test x${ICEDTEA_WITH_CACAO} = "xyes"; then
    CACAO_OPTION="--enable-cacao";
fi

if test x${CACAO_ZIP} != "x"; then
    CACAO_ZIP_OPTION="--with-cacao-src-zip=${CACAO_ZIP}";
fi

if test x${ICEDTEA_WITH_SHARK} = "xyes"; then
    SHARK_OPTION="--enable-shark";
    PATH=${LLVM_INSTALL}/bin:$PATH
fi

if test x${ICEDTEA_WITH_PULSEAUDIO} = "xyes"; then
    PULSEAUDIO_OPTION="--enable-pulse-java";
fi

if test x${ICEDTEA_WITH_VISUALVM} = "xyes"; then
    VISUALVM_OPTION="--enable-visualvm \
    --with-visualvm-src-zip=${VISUALVM_ZIP} \
    --with-netbeans-profiler-src-zip=${NETBEANS_PROFILER_ZIP} \
    --with-netbeans-basic-cluster-src-zip=${NETBEANS_BASIC_CLUSTER_ZIP}"
fi

RT_JAR=${CLASSPATH_INSTALL}/share/classpath/glibj.zip

CONFIG_OPTS="--with-parallel-jobs=${PARALLEL_JOBS} --with-libgcj-jar=${GCJ_JDK_INSTALL}/jre/lib/rt.jar \
    --with-gcj-home=${GCJ_JDK_INSTALL} ${ZIP_OPTION} ${DIR_OPTION} --without-rhino \
    --with-java=${GCJ_JDK_INSTALL}/bin/java --with-javah=${GCJ_JDK_INSTALL}/bin/javah \
    --with-jar=${GCJ_JDK_INSTALL}/bin/jar --with-rmic=${GCJ_JDK_INSTALL}/bin/rmic --disable-docs \
    ${CACAO_OPTION} ${CACAO_ZIP_OPTION} ${SHARK_OPTION} ${VISUALVM_OPTION} ${PULSEAUDIO_OPTION} \
    --with-icedtea-home=${ICEDTEA_INSTALL} ${OPTS}"

(cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck;
else
    make && echo DONE
fi) 2>&1 | tee $ICEDTEA_HOME/errors
