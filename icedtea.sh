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
    OPENJDK_DIR=$OPENJDK6_DIR;
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
elif [ $(echo $0|grep 'nio2') ]; then
    VERSION=icedtea;
    BUILD=nio2;
    OPTS="--with-icedtea --with-project=${BUILD}";
elif [ $(echo $0|grep 'zero6') ]; then
    VERSION=icedtea6;
    BUILD=zero;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'zero') ]; then
    VERSION=icedtea;
    BUILD=zero;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'no-bootstrap') ]; then
    VERSION=icedtea;
    BUILD=icedtea-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-icedtea";
elif [ $(echo $0|grep 'icedtea-1.9') ]; then
    VERSION=icedtea;
    BUILD=icedtea-1.7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
else
    VERSION=icedtea;
    BUILD=icedtea;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="";
fi

if test x${VERSION} = "xicedtea6"; then
    if test x${HOTSPOT6_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT6_ZIP}";
    fi
else
    if test x${CORBA_ZIP} != "x"; then
	CORBA_ZIP_OPTION="--with-corba-src-zip=${CORBA_ZIP}";
    fi
    if test x${JAXP_ZIP} != "x"; then
	JAXP_ZIP_OPTION="--with-jaxp-src-zip=${JAXP_ZIP}";
    fi
    if test x${JAXWS_ZIP} != "x"; then
	JAXWS_ZIP_OPTION="--with-jaxws-src-zip=${JAXWS_ZIP}";
    fi
    if test x${JDK_ZIP} != "x"; then
	JDK_ZIP_OPTION="--with-jdk-src-zip=${JDK_ZIP}";
    fi
    if test x${LANGTOOLS_ZIP} != "x"; then
	LANGTOOLS_ZIP_OPTION="--with-langtools-src-zip=${LANGTOOLS_ZIP}";
    fi
    if test x${HOTSPOT_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT_ZIP}";
    fi
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

if test x${ICEDTEA_WITH_NATIVE_ECJ} = "xyes"; then
    GCJ_OPTION="--with-gcj";
fi

if test x${ICEDTEA_WITH_RHINO} = "xno"; then
    RHINO_OPTION="--without-rhino";
fi

if test x${ICEDTEA_WITH_DOCS} = "xno"; then
    DOCS_OPTION="--disable-docs";
fi

if test x${ICEDTEA_JAVAH} = "x"; then
    JAVAH_OPTION="--with-javah=${GCJ_JDK_INSTALL}/bin/javah";
else
    JAVAH_OPTION="--with-javah=${ICEDTEA_JAVAH}";
fi

RT_JAR=${CLASSPATH_INSTALL}/share/classpath/glibj.zip

CONFIG_OPTS="--with-parallel-jobs=${PARALLEL_JOBS} \
    --with-gcj-home=${GCJ_JDK_INSTALL} ${ZIP_OPTION} ${DIR_OPTION} ${RHINO_OPTION} \
    --with-java=${GCJ_JDK_INSTALL}/bin/java ${JAVAH_OPTION} \
    --with-jar=${GCJ_JDK_INSTALL}/bin/jar --with-rmic=${GCJ_JDK_INSTALL}/bin/rmic ${DOCS_OPTION} \
    ${CACAO_OPTION} ${CACAO_ZIP_OPTION} ${SHARK_OPTION} ${VISUALVM_OPTION} ${PULSEAUDIO_OPTION} \
    --with-icedtea-home=${ICEDTEA_INSTALL} ${GCJ_OPTION} ${HOTSPOT_ZIP_OPTION} ${CORBA_ZIP_OPTION} \
    ${JAXP_ZIP_OPTION} ${JAXWS_ZIP_OPTION} ${JDK_ZIP_OPTION} ${LANGTOOLS_ZIP_OPTION} ${OPTS}"

(PATH=/bin:/usr/bin ./autogen.sh &&
cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck;
elif test "$BUILD" = "zero"; then
    make icedtea-ecj && echo DONE
else
    make && 
    rm -rf ${INSTALL_DIR}/${BUILD} &&
    mv ${BUILD_DIR}/openjdk${DIR}/build/${OS}-${ARCH}/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
    echo DONE
fi) 2>&1 | tee $ICEDTEA_HOME/errors
