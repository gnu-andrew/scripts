#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

CFLAGS="-O2 -pipe -march=core2 -ggdb -mno-tls-direct-seg-refs"
ICEDTEA_BUILD_OPT="--with-openjdk=${ICEDTEA6_INSTALL}"
if [ $(echo $0|grep 'icedtea6-1.2') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.2;
    OPENJDK_ZIP=$OPENJDK6_B09_ZIP;
    OPENJDK_DIR=$OPENJDK6_B09_DIR;
    RELEASE="1.2"
    OPTS="--disable-plugin --with-gcj-home=${SYSTEM_GCJ}"
elif [ $(echo $0|grep 'icedtea6-1.5') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.5;
    OPENJDK_ZIP=$OPENJDK6_B16_ZIP;
    OPENJDK_DIR=$OPENJDK6_B16_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B14_ZIP;
    RELEASE="1.5"
    OPTS="--disable-plugin"
elif [ $(echo $0|grep 'icedtea6-1.6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.6;
    OPENJDK_ZIP=$OPENJDK6_B16_ZIP;
    OPENJDK_DIR=$OPENJDK6_B16_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B14_ZIP;
    RELEASE="1.6"
    OPTS="--disable-plugin --disable-npplugin"
    HOTSPOT6_BUILD=$HOTSPOT6_1_6_BUILD
elif [ $(echo $0|grep 'icedtea6-1.7') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.7;
    OPENJDK_ZIP=$OPENJDK6_B17_ZIP;
    OPENJDK_DIR=$OPENJDK6_B17_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B16_ZIP;
    RELEASE="1.7"
elif [ $(echo $0|grep 'icedtea6-1.8') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.8;
    OPENJDK_ZIP=$OPENJDK6_B18_ZIP;
    OPENJDK_DIR=$OPENJDK6_B18_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B16_ZIP;
    RELEASE="1.8"
elif [ $(echo $0|grep 'icedtea6-hg') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-hg;
    OPENJDK_DIR=$OPENJDK6_DIR;
    JAXP6_DROP_ZIP=$JAXP6_HG_DROP_ZIP
    JAXWS6_DROP_ZIP=$JAXWS6_HG_DROP_ZIP
    JAF6_DROP_ZIP=$JAF6_HG_DROP_ZIP
    RELEASE="hg"
    HOTSPOT6_BUILD=$HOTSPOT6_HG_BUILD
    HOTSPOT6_ZIP=$HOTSPOT6_HG_ZIP
    OPTS="--with-openjdk --enable-zero"
elif [ $(echo $0|grep 'icedtea6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
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
elif [ $(echo $0|grep 'shark') ]; then
    VERSION=icedtea7;
    BUILD=shark7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
elif [ $(echo $0|grep 'cacao6') ]; then
    VERSION=icedtea6;
    BUILD=cacao-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
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
    OPTS="${ICEDTEA_BUILD_OPT}";
elif [ $(echo $0|grep 'no-bootstrap') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--disable-bootstrap --with-jdk-home=${SYSTEM_ICEDTEA6}";
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
    OPTS="--with-additional-vms=cacao,shark";
elif [ $(echo $0|grep 'addvm') ]; then
    VERSION=icedtea7;
    BUILD=addvm-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-additional-vms=cacao,shark";
else
    VERSION=icedtea7;
    BUILD=icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="";
fi

BUILD_DIR=${WORKING_DIR}/${BUILD}
ICEDTEA_ROOT="http://icedtea.classpath.org/hg"
ANDREW_ROOT="http://icedtea.classpath.org/people/andrew"

# Dead with b16
#if test x${VERSION} = "xicedtea6"; then
#    DIR="/control";
#fi

if test "x${RELEASE}" = "x"; then
    ICEDTEA_URL=${ICEDTEA_ROOT}/${VERSION};
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION};
elif test "x${RELEASE}" = "xhg"; then
    ICEDTEA_URL=${ANDREW_ROOT}/${VERSION}-${RELEASE};
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}-${RELEASE};
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
    if test x${JAXP6_DROP_ZIP} != "x"; then
	JAXP_DROP_ZIP_OPTION="--with-jaxp-drop-zip=${JAXP6_DROP_ZIP}";
    fi
    if test x${JAF6_DROP_ZIP} != "x"; then
	JAF_DROP_ZIP_OPTION="--with-jaf-drop-zip=${JAF6_DROP_ZIP}";
    fi
    if test x${JAXWS6_DROP_ZIP} != "x"; then
	JAXWS_DROP_ZIP_OPTION="--with-jaxws-drop-zip=${JAXWS6_DROP_ZIP}";
    fi
    if test x${HOTSPOT6_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT6_BUILD}";
    fi
    if test x${CACAO6_ZIP} != "x"; then
	CACAO_ZIP_OPTION="--with-cacao-src-zip=${CACAO6_ZIP}";
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
    if test x${JAXP7_DROP_ZIP} != "x"; then
	JAXP_DROP_ZIP_OPTION="--with-jaxp-drop-zip=${JAXP7_DROP_ZIP}";
    fi
    if test x${JAF7_DROP_ZIP} != "x"; then
	JAF_DROP_ZIP_OPTION="--with-jaf-drop-zip=${JAF7_DROP_ZIP}";
    fi
    if test x${JAXWS7_DROP_ZIP} != "x"; then
	JAXWS_DROP_ZIP_OPTION="--with-jaxws-drop-zip=${JAXWS7_DROP_ZIP}";
    fi
    if test x${HOTSPOT7_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT7_BUILD}";
    fi
    if test x${CACAO7_ZIP} != "x"; then
	CACAO_ZIP_OPTION="--with-cacao-src-zip=${CACAO7_ZIP}";
    fi
fi

echo "Building ${ICEDTEA_HOME} in ${BUILD_DIR}..."

if test x$1 != "xquick"; then
    echo "Building from scratch"
    if [ -e ${BUILD_DIR} ]; then
	chmod -R u+w ${BUILD_DIR}
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

if test x${ICEDTEA_WITH_SHARK} = "xyes" \
    || [ $(echo ${BUILD}|grep 'shark') ]; then
    SHARK_OPTION="--enable-shark";
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
PATH=${LLVM_INSTALL}/bin:$PATH

(PATH=/bin:/usr/bin ./autogen.sh &&
cd ${BUILD_DIR} &&
$ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make distcheck;
elif echo "$BUILD" | grep "zero6"; then
    make icedtea-ecj && echo DONE
elif echo "$BUILD" | grep "zero"; then
    make icedtea-boot && echo DONE
else
    CFLAGS=${CFLAGS} make && echo COMPILED &&
    rm -rf ${INSTALL_DIR}/${BUILD} &&
    (if [ -e ${BUILD_DIR}/openjdk.build ] ; then
	mv ${BUILD_DIR}/openjdk.build/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
	ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk.build/j2sdk-image
    else
	mv ${BUILD_DIR}/openjdk/build/${OS}-${JDK_ARCH}/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
	ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk/build/${OS}-${JDK_ARCH}/j2sdk-image
    fi) &&
    echo DONE
fi) 2>&1 | tee $ICEDTEA_HOME/errors
