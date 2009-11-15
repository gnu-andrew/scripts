#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
#JAVAC=
#JAVACFLAGS=
JAVA_HOME=
#JDK_HOME=

CFLAGS="-O2 -pipe -march=core2 -ggdb -mno-tls-direct-seg-refs"
ICEDTEA_BUILD_OPT="--with-openjdk=${ICEDTEA6_INSTALL}"
if [ $(echo $0|grep 'icedtea6-1.5') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.5;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    RELEASE="1.5"
elif [ $(echo $0|grep 'icedtea6-1.6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    RELEASE="1.6"
elif [ $(echo $0|grep 'icedtea6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
elif [ $(echo $0|grep 'cvmi') ]; then
    VERSION=icedtea7;
    BUILD=cvmi;
    OPENJDK_ZIP=$CVMI_ZIP;
    OPENJDK_DIR=$CVMI_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
elif [ $(echo $0|grep 'caciocavallo') ]; then
    VERSION=icedtea7;
    BUILD=caciocavallo;
    OPENJDK_ZIP=$CACIOCAVALLO_ZIP;
    OPENJDK_DIR=$CACIOCAVALLO_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
elif [ $(echo $0|grep 'closures') ]; then
    VERSION=icedtea7;
    BUILD=closures;
    OPENJDK_ZIP=$CLOSURES_ZIP;
    OPENJDK_DIR=$CLOSURES_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
elif [ $(echo $0|grep 'nio2') ]; then
    VERSION=icedtea7;
    BUILD=nio2;
    OPENJDK_ZIP=$NIO2_ZIP;
    OPENJDK_DIR=$NIO2_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
elif [ $(echo $0|grep 'zero6') ]; then
    VERSION=icedtea6;
    BUILD=zero6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'zero') ]; then
    VERSION=icedtea7;
    BUILD=zero7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'shark6') ]; then
    VERSION=icedtea6;
    BUILD=shark6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
elif [ $(echo $0|grep 'shark') ]; then
    VERSION=icedtea7;
    BUILD=shark7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
elif [ $(echo $0|grep 'cacao6') ]; then
    VERSION=icedtea6;
    BUILD=cacao-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    OPTS="--enable-cacao";
elif [ $(echo $0|grep 'cacao') ]; then
    VERSION=icedtea7;
    BUILD=cacao-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-cacao";
elif [ $(echo $0|grep 'no-bootstrap6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    OPTS=${ICEDTEA_BUILD_OPT};
elif [ $(echo $0|grep 'no-bootstrap') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--disable-bootstrap --with-jdk-home=${ICEDTEA6_INSTALL}";
elif [ $(echo $0|grep 'icedtea-1.9') ]; then
    VERSION=icedtea7;
    BUILD=icedtea-1.9;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    RELEASE="1.9"
elif [ $(echo $0|grep 'addvm6') ]; then
    VERSION=icedtea6;
    BUILD=addvm-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$OPENJDK6_DIR;
    OPTS="--with-additional-vms=cacao,zero";
elif [ $(echo $0|grep 'addvm') ]; then
    VERSION=icedtea7;
    BUILD=addvm-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-additional-vms=cacao,zero";
else
    VERSION=icedtea7;
    BUILD=icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="";
fi

BUILD_DIR=${WORKING_DIR}/${BUILD}
ICEDTEA_ROOT="http://icedtea.classpath.org/hg"

# Dead with b16
#if test x${VERSION} = "xicedtea6"; then
#    DIR="/control";
#fi

if test "x${RELEASE}" = "x"; then
    ICEDTEA_URL=${ICEDTEA_ROOT}/${VERSION};
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION};
else
    ICEDTEA_URL=${ICEDTEA_ROOT}/release/${VERSION}-${RELEASE}
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}-${RELEASE}
fi

if test x${VERSION} = "xicedtea6"; then
    if test x${HOTSPOT6_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT6_ZIP}";
    fi
    if test x${ICEDTEA6_WITH_NIO2} = "xyes"; then
	NIO2_OPTION="--enable-nio2";
    fi
    if test x${HOTSPOT6_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT6_BUILD}";
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
    if test x${JAXP_DROP_ZIP} != "x"; then
	JAXP_DROP_ZIP_OPTION="--with-jaxp-drop-zip=${JAXP_DROP_ZIP}";
    fi
    if test x${JAF_DROP_ZIP} != "x"; then
	JAF_DROP_ZIP_OPTION="--with-jaf-drop-zip=${JAF_DROP_ZIP}";
    fi
    if test x${JAXWS_DROP_ZIP} != "x"; then
	JAXWS_DROP_ZIP_OPTION="--with-jaxws-drop-zip=${JAXWS_DROP_ZIP}";
    fi
    if test x${HOTSPOT7_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT7_BUILD}";
    fi
fi

echo "Building ${ICEDTEA_HOME} in ${BUILD_DIR}..."

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
    hg clone ${ICEDTEA_URL};
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

if test x${ICEDTEA_WITH_SHARK} = "xyes" || [ $(echo ${BUILD}|grep 'shark') ]; then
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

if test x${ICEDTEA_WITH_NIMBUS} = "xno"; then
    NIMBUS_OPTION="--disable-nimbus";
fi

if test x${ICEDTEA_WITH_SYSTEMTAP} = "xyes"; then
    SYSTEMTAP_OPTION="--enable-systemtap";
fi

if test x${ICEDTEA_WITH_XRENDER} = "xno"; then
    XRENDER_OPTION="--disable-xrender";
fi

if test x${ICEDTEA_WITH_PLUGIN} = "xno"; then
    PLUGIN_OPTION="--disable-plugin";
fi

if test x${ICEDTEA_WITH_NEW_PLUGIN} = "xyes"; then
    NEW_PLUGIN_OPTION="--enable-npplugin";
fi

if test x${ICEDTEA_JAVAH} = "x"; then
    JAVAH_OPTION="--with-javah=${GCJ_JDK_INSTALL}/bin/javah";
else
    JAVAH_OPTION="--with-javah=${ICEDTEA_JAVAH}";
fi

if test x${ICEDTEA_WITH_NSS} = "xyes"; then
    NSS_OPTION="--enable-nss";
fi

RT_JAR=${CLASSPATH_INSTALL}/share/classpath/glibj.zip

# Old
# --with-java=${GCJ_JDK_INSTALL}/bin/java ${JAVAH_OPTION} \
# --with-jar=${GCJ_JDK_INSTALL}/bin/jar --with-rmic=${GCJ_JDK_INSTALL}/bin/rmic

CONFIG_OPTS="--with-parallel-jobs=${PARALLEL_JOBS} \
    --with-jdk-home=${GCJ_JDK_INSTALL} ${ZIP_OPTION} ${DIR_OPTION} ${RHINO_OPTION} ${DOCS_OPTION} \
    ${CACAO_OPTION} ${CACAO_ZIP_OPTION} ${SHARK_OPTION} ${VISUALVM_OPTION} ${PULSEAUDIO_OPTION} \
    ${GCJ_OPTION} ${HOTSPOT_ZIP_OPTION} ${CORBA_ZIP_OPTION} \
    ${JAXP_ZIP_OPTION} ${JAXWS_ZIP_OPTION} ${JDK_ZIP_OPTION} ${LANGTOOLS_ZIP_OPTION} ${NIMBUS_OPTION} \
    ${SYSTEMTAP_OPTION} --with-abs-install-dir=${INSTALL_DIR} ${NIMBUS_GEN_OPTION} ${XRENDER_OPTION} \
    ${PLUGIN_OPTION} ${NEW_PLUGIN_OPTION} ${CACAO_ZIP_OPTION} ${NSS_OPTION} ${NIO2_OPTION} ${OPTS} \
    ${JAXP_DROP_ZIP_OPTION} ${JAF_DROP_ZIP_OPTION} ${JAXWS_DROP_ZIP_OPTION} ${HOTSPOT_BUILD_OPTION}"

(PATH=/bin:/usr/bin ./autogen.sh &&
cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck;
elif echo "$BUILD" | grep "zero"; then
    make icedtea-boot && echo DONE
else
    CFLAGS=${CFLAGS} make && 
    rm -rf ${INSTALL_DIR}/${BUILD} &&
    mv ${BUILD_DIR}/openjdk${DIR}/build/${OS}-${ARCH}/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
    ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk${DIR}/build/${OS}-${ARCH}/j2sdk-image &&
    echo DONE
fi) 2>&1 | tee $ICEDTEA_HOME/errors
