#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

ICEDTEA_BUILD_OPT="--with-openjdk=${SYSTEM_ICEDTEA6} --disable-bootstrap --with-jdk-home=${SYSTEM_ICEDTEA6}"
if [ $(echo $0|grep 'icedtea6-1.2') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.2;
    OPENJDK_ZIP=$OPENJDK6_B09_ZIP;
    OPENJDK_DIR=$OPENJDK6_B09_DIR;
    RELEASE="1.2"
    OPTS="--disable-plugin --with-gcj-home=${SYSTEM_GCJ}"
    MAKE_OPTS=
elif [ $(echo $0|grep 'icedtea6-1.5') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.5;
    OPENJDK_ZIP=$OPENJDK6_B16_ZIP;
    OPENJDK_DIR=$OPENJDK6_B16_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B14_ZIP;
    RELEASE="1.5"
    OPTS="--disable-plugin"
    MAKE_OPTS=
elif [ $(echo $0|grep 'icedtea6-1.6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.6;
    OPENJDK_ZIP=$OPENJDK6_B16_ZIP;
    OPENJDK_DIR=$OPENJDK6_B16_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B14_ZIP;
    RELEASE="1.6"
    HOTSPOT6_BUILD=$HOTSPOT6_1_6_BUILD
    MAKE_OPTS=
elif [ $(echo $0|grep 'icedtea6-1.7') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.7;
    OPENJDK_ZIP=$OPENJDK6_B17_ZIP;
    OPENJDK_DIR=$OPENJDK6_B17_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B16_ZIP;
    HOTSPOT6_BUILD=$HOTSPOT6_1_7_BUILD
    RELEASE="1.7"
    MAKE_OPTS=
elif [ $(echo $0|grep 'icedtea6-1.8') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.8;
    OPENJDK_ZIP=$OPENJDK6_B18_ZIP;
    OPENJDK_DIR=$OPENJDK6_B18_DIR;
    HOTSPOT6_ZIP=$HOTSPOT6_B16_ZIP;
    HOTSPOT6_BUILD=$HOTSPOT6_1_8_BUILD
    JAXP6_DROP_ZIP=$JAXP6_18_DROP_ZIP
    JAXWS6_DROP_ZIP=$JAXWS6_18_DROP_ZIP
    JAF6_DROP_ZIP=$JAF6_18_DROP_ZIP
    RELEASE="1.8"
    MAKE_OPTS=
    ALTERNATIVE_JAVAH=${GCJ_JAVAH}
    LEGACY_OPTS="--with-gcj-home=${CLASSPATH_JDK_INSTALL}"
elif [ $(echo $0|grep 'icedtea6-1.9') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.9;
    OPENJDK_ZIP=$OPENJDK6_B20_ZIP;
    JAXP6_DROP_ZIP=$JAXP6_19_DROP_ZIP
    JAXWS6_DROP_ZIP=$JAXWS6_19_DROP_ZIP
    JAF6_DROP_ZIP=$JAF6_19_DROP_ZIP
    HOTSPOT6_ZIP=$HOTSPOT6_B19_ZIP
    HOTSPOT6_BUILD=$HOTSPOT6_1_9_BUILD
    RELEASE="1.9"
    MAKE_OPTS=
    ALTERNATIVE_JAVAH=${GCJ_JAVAH}
elif [ $(echo $0|grep 'icedtea6-1.10') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.10;
    OPENJDK_ZIP=$OPENJDK6_B22_ZIP;
    JAXP6_DROP_ZIP=$JAXP6_1_10_DROP_ZIP
    JAXWS6_DROP_ZIP=$JAXWS6_1_10_DROP_ZIP
    JAF6_DROP_ZIP=$JAF6_1_10_DROP_ZIP
    HOTSPOT6_ZIP=$HOTSPOT6_1_10_ZIP
    HOTSPOT6_BUILD=$HOTSPOT6_1_10_BUILD
    RELEASE="1.10"
elif [ $(echo $0|grep 'icedtea6-1.11') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.11;
    OPENJDK_ZIP=$OPENJDK6_B24_ZIP;
    RELEASE="1.11"
    #OPTS="--disable-bootstrap --with-jdk-home=${SYSTEM_ICEDTEA6}"
elif [ $(echo $0|grep 'icedtea6-1.12') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.12;
    OPENJDK_ZIP=$OPENJDK6_B27_ZIP;
    RELEASE="1.12"
elif [ $(echo $0|grep 'icedtea6-1.13') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-1.13;
    OPENJDK_ZIP=$OPENJDK6_B39_ZIP;
    RELEASE="1.13"
elif [ $(echo $0|grep 'icedtea6-hg') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-hg;
    OPENJDK_DIR=$OPENJDK6_DIR;
    RELEASE="hg"
    HOTSPOT6_BUILD=$HOTSPOT6_HG_BUILD
    HOTSPOT6_ZIP=$HOTSPOT6_HG_ZIP
    #OPTS="--with-jdk-home=${CACAO_JDK_INSTALL}"
elif [ $(echo $0|grep 'icedtea6-sec') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-sec;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    RELEASE="sec"
elif [ $(echo $0|grep 'icedtea6-bootstrap6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-icedtea6-bootstrap;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="--with-jdk-home=${BOOTSTRAP_ICEDTEA6}"
    MAKE_OPTS=""
    USE_ECJ="no"
elif [ $(echo $0|grep 'icedtea6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    CLEAN_TREE=no;
    HOTSPOT6_ZIP=$HOTSPOT6_ZIP;
    HOTSPOT6_BUILD="hs23"
elif [ $(echo $0|grep 'icedtea7-2.1') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.1;
    OPENJDK_ZIP=$OPENJDK7_21_ZIP;
    CORBA7_ZIP=$CORBA7_21_ZIP;
    JAXP7_ZIP=$JAXP7_21_ZIP;
    JAXWS7_ZIP=$JAXWS7_21_ZIP;
    JDK7_ZIP=$JDK7_21_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_21_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_21_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.1";
    #OPTS="--disable-bootstrap --enable-zero"
elif [ $(echo $0|grep 'icedtea7-2.2') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.2;
    OPENJDK_ZIP=$OPENJDK7_22_ZIP;
    CORBA7_ZIP=$CORBA7_22_ZIP;
    JAXP7_ZIP=$JAXP7_22_ZIP;
    JAXWS7_ZIP=$JAXWS7_22_ZIP;
    JDK7_ZIP=$JDK7_22_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_22_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_22_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.2";
elif [ $(echo $0|grep 'icedtea7-2.3') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.3;
    OPENJDK_ZIP=$OPENJDK7_23_ZIP;
    CORBA7_ZIP=$CORBA7_23_ZIP;
    JAXP7_ZIP=$JAXP7_23_ZIP;
    JAXWS7_ZIP=$JAXWS7_23_ZIP;
    JDK7_ZIP=$JDK7_23_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_23_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_23_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.3"
    OPTS="--with-javac=${OLD_ECJ} --enable-zero --with-ecj-jar=/bin/false"
elif [ $(echo $0|grep 'icedtea7-2.4') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.4;
    OPENJDK_ZIP=$OPENJDK7_24_ZIP;
    CORBA7_ZIP=$CORBA7_24_ZIP;
    JAXP7_ZIP=$JAXP7_24_ZIP;
    JAXWS7_ZIP=$JAXWS7_24_ZIP;
    JDK7_ZIP=$JDK7_24_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_24_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_24_ZIP;
    #HOTSPOT7_ZIP=$AARCH64_24_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.4"
    #OPTS="--with-jdk-home=${SYSTEM_ICEDTEA6} --enable-zero"
    #OPENJDK_DIR=/home/andrew/projects/openjdk/upstream/icedtea7-2.4
    #OPTS="--with-hotspot-build=aarch64 --enable-zero"
elif [ $(echo $0|grep 'icedtea7-2.5') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.5;
    OPENJDK_ZIP=$OPENJDK7_25_ZIP;
    CORBA7_ZIP=$CORBA7_25_ZIP;
    JAXP7_ZIP=$JAXP7_25_ZIP;
    JAXWS7_ZIP=$JAXWS7_25_ZIP;
    JDK7_ZIP=$JDK7_25_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_25_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_25_ZIP;
    #HOTSPOT7_ZIP=$AARCH64_25_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.5"
    #OPTS="--with-hotspot-build=aarch64"
    #OPTS="--with-jdk-home=${INSTALL_DIR}/icedtea7-2.4"
    #USE_ECJ="no"
    #OPTS="--enable-cacao"
    #USE_ECJ="no"
    #OPTS="--with-jdk-home=${BOOTSTRAP_ICEDTEA6}"
elif [ $(echo $0|grep 'icedtea7-2.6') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.6;
    OPENJDK_ZIP=$OPENJDK7_26_ZIP;
    CORBA7_ZIP=$CORBA7_26_ZIP;
    JAXP7_ZIP=$JAXP7_26_ZIP;
    JAXWS7_ZIP=$JAXWS7_26_ZIP;
    JDK7_ZIP=$JDK7_26_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_26_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_26_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.6"
    #OPTS="--enable-cacao"
elif [ $(echo $0|grep 'icedtea7-2.0') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-2.0;
    OPENJDK_ZIP=$OPENJDK7_20_ZIP;
    CORBA7_ZIP=$CORBA7_20_ZIP;
    JAXP7_ZIP=$JAXP7_20_ZIP;
    JAXWS7_ZIP=$JAXWS7_20_ZIP;
    JDK7_ZIP=$JDK7_20_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_20_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_20_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="2.0"
elif [ $(echo $0|grep 'icedtea8-3.0') ]; then
    VERSION=icedtea8;
    BUILD=icedtea8-3.0;
    OPENJDK_ZIP=$OPENJDK8_30_ZIP;
    CORBA8_ZIP=$CORBA8_30_ZIP;
    JAXP8_ZIP=$JAXP8_30_ZIP;
    JAXWS8_ZIP=$JAXWS8_30_ZIP;
    JDK8_ZIP=$JDK8_30_ZIP;
    LANGTOOLS8_ZIP=$LANGTOOLS8_30_ZIP;
    NASHORN8_ZIP=$NASHORN8_30_ZIP;
    HOTSPOT8_ZIP=$HOTSPOT8_30_ZIP;
    CLEAN_TREE=no;
    RELEASE="3.0"
elif [ $(echo $0|grep 'icedtea7-bootstrap7-gcj') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-icedtea7-bootstrap-gcj;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-jdk-home=${BOOTSTRAP_ICEDTEA7} --with-gcj --with-ecj-jar=${GCJ_ECJ_JAR}"
    USE_ECJ="no"
elif [ $(echo $0|grep 'icedtea7-bootstrap7') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-icedtea7-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-jdk-home=${BOOTSTRAP_ICEDTEA7}"
    USE_ECJ="no"
elif [ $(echo $0|grep 'icedtea7-bootstrap6') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-icedtea6-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-jdk-home=${BOOTSTRAP_ICEDTEA6}"
    USE_ECJ="no"
elif [ $(echo $0|grep 'icedtea7-nss') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7;
    OPENJDK_ZIP=$OPENJDK7_24_ZIP;
    CORBA7_ZIP=$CORBA7_24_ZIP;
    JAXP7_ZIP=$JAXP7_24_ZIP;
    JAXWS7_ZIP=$JAXWS7_24_ZIP;
    JDK7_ZIP=$JDK7_24_ZIP;
    LANGTOOLS7_ZIP=$LANGTOOLS7_24_ZIP;
    HOTSPOT7_ZIP=$HOTSPOT7_24_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    RELEASE="nss";
elif [ $(echo $0|grep 'icedtea7-aarch64') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-aarch64;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    HOTSPOT7_ZIP=$AARCH64_ZIP;
    MAKE_OPTS="";
    CLEAN_TREE=no;
    OPTS="--with-hotspot-build=aarch64"
elif [ $(echo $0|grep 'icedtea7') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    MAKE_OPTS="";
    CLEAN_TREE=no;
elif [ $(echo $0|grep 'cvmi') ]; then
    VERSION=icedtea7;
    BUILD=cvmi;
    OPENJDK_ZIP=$CVMI_ZIP;
    OPENJDK_DIR=$CVMI_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'caciocavallo') ]; then
    VERSION=icedtea7;
    BUILD=caciocavallo;
    OPENJDK_ZIP=$CACIOCAVALLO_ZIP;
    OPENJDK_DIR=$CACIOCAVALLO_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'closures') ]; then
    VERSION=icedtea7;
    BUILD=closures;
    OPENJDK_ZIP=$CLOSURES_ZIP;
    OPENJDK_DIR=$CLOSURES_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'nio2') ]; then
    VERSION=icedtea7;
    BUILD=nio2;
    OPENJDK_ZIP=$NIO2_ZIP;
    OPENJDK_DIR=$NIO2_DIR;
    OPTS="${ICEDTEA_BUILD_OPT} --with-project=${BUILD}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'zero6') ]; then
    VERSION=icedtea6;
    BUILD=zero6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'zero7') ]; then
    VERSION=icedtea7;
    BUILD=zero7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'zero8') ]; then
    VERSION=icedtea8;
    BUILD=zero8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'zero') ]; then
    VERSION=icedtea8;
    BUILD=zero8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    OPTS="--enable-zero";
elif [ $(echo $0|grep 'shark6') ]; then
    VERSION=icedtea6;
    BUILD=shark6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
elif [ $(echo $0|grep 'shark7') ]; then
    VERSION=icedtea7;
    BUILD=shark7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
elif [ $(echo $0|grep 'shark') ]; then
    VERSION=icedtea8;
    BUILD=shark8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
elif [ $(echo $0|grep 'cacao6') ]; then
    VERSION=icedtea6;
    BUILD=cacao-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="--enable-cacao";
elif [ $(echo $0|grep 'cacao7') ]; then
    VERSION=icedtea7;
    BUILD=cacao-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-cacao";
elif [ $(echo $0|grep 'jamvm6') ]; then
    VERSION=icedtea6;
    BUILD=jamvm-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="--enable-jamvm";
elif [ $(echo $0|grep 'jamvm7') ]; then
    VERSION=icedtea7;
    BUILD=jamvm-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--enable-jamvm";
elif [ $(echo $0|grep 'cacao') ]; then
    VERSION=icedtea8;
    BUILD=cacao-icedtea8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    OPTS="--enable-cacao";
elif [ $(echo $0|grep 'jamvm') ]; then
    VERSION=icedtea8;
    BUILD=jamvm-icedtea8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    OPTS="--enable-jamvm";
elif [ $(echo $0|grep 'no-bootstrap6') ]; then
    VERSION=icedtea6;
    BUILD=icedtea6-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="${ICEDTEA_BUILD_OPT}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'no-bootstrap') ]; then
    VERSION=icedtea7;
    BUILD=icedtea7-no-bootstrap;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="${ICEDTEA_BUILD_OPT}";
    USE_ECJ="no"
elif [ $(echo $0|grep 'icedtea-1.9') ]; then
    VERSION=icedtea7;
    BUILD=icedtea-1.9;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    RELEASE="1.9"
    MAKE_OPTS=
elif [ $(echo $0|grep 'addvm6') ]; then
    VERSION=icedtea6;
    BUILD=addvm-icedtea6;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPTS="--with-additional-vms=cacao,shark";
elif [ $(echo $0|grep 'addvm7') ]; then
    VERSION=icedtea7;
    BUILD=addvm-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    OPTS="--with-additional-vms=cacao,shark";
elif [ $(echo $0|grep 'addvm') ]; then
    VERSION=icedtea8;
    BUILD=addvm-icedtea8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    OPTS="--with-additional-vms=cacao,shark";
elif [ $(echo $0|grep 'azul') ]; then
    VERSION=icedtea6;
    BUILD=azul;
    OPENJDK_ZIP=$OPENJDK6_ZIP;
    OPENJDK_DIR=$AZUL_DIR;
    OPTS="--enable-azul --with-azul-hotspot=${AZHOTSPOT} ${ICEDTEA_BUILD_OPT}";
    RELEASE="mri";
    USE_ECJ="no"
elif [ $(echo $0|grep 'ppc7') ]; then
    VERSION=icedtea7;
    BUILD=ppc-icedtea7;
    OPENJDK_ZIP=$OPENJDK7_ZIP;
    OPENJDK_DIR=$OPENJDK7_DIR;
    HOTSPOT7_ZIP=$PPC7_ZIP;
    OPTS="--with-hotspot-build=ppc";
else
    VERSION=icedtea8;
    BUILD=icedtea8;
    OPENJDK_ZIP=$OPENJDK8_ZIP;
    OPENJDK_DIR=$OPENJDK8_DIR;
    CLEAN_TREE=no;
fi

BUILD_DIR=${WORKING_DIR}/${BUILD}
ICEDTEA_ROOT="http://icedtea.classpath.org/hg"

if test x${VERSION} = "xicedtea8"; then
    DIR="/images";
fi

if test "x${RELEASE}" = "x"; then
    ICEDTEA_URL=${ICEDTEA_ROOT}/${VERSION};
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION};
elif test "x${RELEASE}" = "xhg"; then
    ICEDTEA_URL=${ICEDTEA_ROOT}/${VERSION}-${RELEASE};
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}-${RELEASE};
elif test "x${RELEASE}" = "xsec"; then
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}-${RELEASE};
else
    ICEDTEA_URL=${ICEDTEA_ROOT}/release/${VERSION}-${RELEASE}
    ICEDTEA_HOME=${OPENJDK_HOME}/${VERSION}-${RELEASE}
fi

if test x${VERSION} = "xicedtea6"; then
    OPTS="${OPTS} --with-ecj-jar=${GCJ_ECJ_JAR}"
    if test x${HOTSPOT6_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT6_ZIP}";
    fi
    if test x${ICEDTEA6_WITH_NIO2} = "xyes"; then
	NIO2_OPTION="--enable-nio2";
    fi
    if test x${ICEDTEA6_WITH_LCMS2} = "xyes"; then
	LCMS2_OPTION="--enable-lcms2";
    else
	LCMS2_OPTION="--disable-lcms2";
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
    if test x${JAMVM6_ZIP} != "x"; then
	JAMVM_ZIP_OPTION="--with-jamvm-src-zip=${JAMVM6_ZIP}";
    fi
elif test x${VERSION} = "xicedtea7"; then
    if test x${CORBA7_ZIP} != "x"; then
	CORBA_ZIP_OPTION="--with-corba-src-zip=${CORBA7_ZIP}";
    fi
    if test x${JAXP7_ZIP} != "x"; then
	JAXP_ZIP_OPTION="--with-jaxp-src-zip=${JAXP7_ZIP}";
    fi
    if test x${JAXWS7_ZIP} != "x"; then
	JAXWS_ZIP_OPTION="--with-jaxws-src-zip=${JAXWS7_ZIP}";
    fi
    if test x${JDK7_ZIP} != "x"; then
	JDK_ZIP_OPTION="--with-jdk-src-zip=${JDK7_ZIP}";
    fi
    if test x${LANGTOOLS7_ZIP} != "x"; then
	LANGTOOLS_ZIP_OPTION="--with-langtools-src-zip=${LANGTOOLS7_ZIP}";
    fi
    if test x${HOTSPOT7_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT7_ZIP}";
    fi
    if test x${HOTSPOT7_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT7_BUILD}";
    fi
    if test x${CACAO7_ZIP} != "x"; then
	CACAO_ZIP_OPTION="--with-cacao-src-zip=${CACAO7_ZIP}";
    fi
    if test x${JAMVM7_ZIP} != "x"; then
	JAMVM_ZIP_OPTION="--with-jamvm-src-zip=${JAMVM7_ZIP}";
    fi
else
    OPTS="${OPTS} --with-jdk-home=${BOOTSTRAP_ICEDTEA7}" 
    USE_ECJ="no"
    if test x${CORBA8_ZIP} != "x"; then
	CORBA_ZIP_OPTION="--with-corba-src-zip=${CORBA8_ZIP}";
    fi
    if test x${JAXP8_ZIP} != "x"; then
	JAXP_ZIP_OPTION="--with-jaxp-src-zip=${JAXP8_ZIP}";
    fi
    if test x${JAXWS8_ZIP} != "x"; then
	JAXWS_ZIP_OPTION="--with-jaxws-src-zip=${JAXWS8_ZIP}";
    fi
    if test x${JDK8_ZIP} != "x"; then
	JDK_ZIP_OPTION="--with-jdk-src-zip=${JDK8_ZIP}";
    fi
    if test x${LANGTOOLS8_ZIP} != "x"; then
	LANGTOOLS_ZIP_OPTION="--with-langtools-src-zip=${LANGTOOLS8_ZIP}";
    fi
    if test x${NASHORN8_ZIP} != "x"; then
	NASHORN_ZIP_OPTION="--with-nashorn-src-zip=${NASHORN8_ZIP}";
    fi
    if test x${HOTSPOT8_ZIP} != "x"; then
	HOTSPOT_ZIP_OPTION="--with-hotspot-src-zip=${HOTSPOT8_ZIP}";
    fi
    if test x${HOTSPOT8_BUILD} != "x"; then
	HOTSPOT_BUILD_OPTION="--with-hotspot-build=${HOTSPOT8_BUILD}";
    fi
    if test x${CACAO8_ZIP} != "x"; then
	CACAO_ZIP_OPTION="--with-cacao-src-zip=${CACAO8_ZIP}";
    fi
    if test x${JAMVM8_ZIP} != "x"; then
	JAMVM_ZIP_OPTION="--with-jamvm-src-zip=${JAMVM8_ZIP}";
    fi
fi

if test "x${USE_ECJ}" != "xno"; then
   JAVAC_OPTION=" --with-javac=${OLD_ECJ}"
fi

echo "Building ${ICEDTEA_HOME} in ${BUILD_DIR}..."
echo "Additional options: ${OPTS}"

if test x$1 != "xquick"; then
    echo "Building from scratch"
    if [ -e ${BUILD_DIR} ]; then
	chmod -R u+w ${BUILD_DIR}
	if test "x${CLEAN_TREE}" = "xyes" && test -e ${BUILD_DIR}/Makefile; then
	    if ! (make -C ${BUILD_DIR} distclean && rmdir ${BUILD_DIR}) ; then
		echo "Cleaning tree failed.";
		exit -1;
	    fi
	else
	    rm -rf ${BUILD_DIR};
	fi
    fi
fi

if [ ! -e ${BUILD_DIR} ]; then
    mkdir ${BUILD_DIR};
fi

if [ -e $ICEDTEA_HOME ]; then
    cd $ICEDTEA_HOME;
    if ! [ $(echo $BUILD|grep 'hg$') ]; then
	hg pull -u;
    fi
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

if test x${ICEDTEA_WITH_JAMVM} = "xyes"; then
    JAMVM_OPTION="--enable-jamvm";
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

if test x${ICEDTEA_WITH_NETX} = "xno"; then
    PLUGIN_OPTION="--disable-webstart";
fi

if test x${ALTERNATIVE_JAVAH} = "x"; then
    JAVAH_OPTION="--with-javah=${CLASSPATH_JDK_INSTALL}/bin/javah";
else
    JAVAH_OPTION="--with-javah=${ALTERNATIVE_JAVAH}";
fi

if test x${ICEDTEA_WITH_NSS} = "xyes"; then
    NSS_OPTION="--enable-nss";
fi

if test x${ICEDTEA_WITH_TESTS} = "xno"; then
    TESTS_OPTION="--disable-tests"
else
    TESTS_OPTION="--enable-tests"
fi

if test x${ICEDTEA_WITH_JDK_TESTS} = "xno"; then
    TESTS_OPTION="${TESTS_OPTION} --disable-jdk-tests"
else
    TESTS_OPTION="${TESTS_OPTION} --enable-jdk-tests"
fi

if test x${ICEDTEA_WITH_LANGTOOLS_TESTS} = "xno"; then
    TESTS_OPTION="${TESTS_OPTION} --disable-langtools-tests"
else
    TESTS_OPTION="${TESTS_OPTION} --enable-langtools-tests"
fi

if test x${ICEDTEA_WITH_HOTSPOT_TESTS} = "xno"; then
    TESTS_OPTION="${TESTS_OPTION} --disable-hotspot-tests"
else
    TESTS_OPTION="${TESTS_OPTION} --enable-hotspot-tests"
fi

if test x${ICEDTEA_WITH_SYSTEMTAP_TESTS} = "xno"; then
    TESTS_OPTION="${TESTS_OPTION} --disable-systemtap-tests"
else
    TESTS_OPTION="${TESTS_OPTION} --enable-systemtap-tests"
fi

if test x${ICEDTEA_WITH_SYSTEM_LCMS} = "xno"; then
    SYSTEM_LCMS_OPTION="--disable-system-lcms"
else
    SYSTEM_LCMS_OPTION="--enable-system-lcms"
fi

if test x${ICEDTEA_WITH_SYSTEM_ZLIB} = "xno"; then
    SYSTEM_ZLIB_OPTION="--disable-system-zlib"
else
    SYSTEM_ZLIB_OPTION="--enable-system-zlib"
fi

if test x${ICEDTEA_WITH_SYSTEM_JPEG} = "xno"; then
    SYSTEM_JPEG_OPTION="--disable-system-jpeg"
else
    SYSTEM_JPEG_OPTION="--enable-system-jpeg"
fi

if test x${ICEDTEA_WITH_SYSTEM_PNG} = "xno"; then
    SYSTEM_PNG_OPTION="--disable-system-png"
else
    SYSTEM_PNG_OPTION="--enable-system-png"
fi

if test x${ICEDTEA_WITH_SYSTEM_GIF} = "xno"; then
    SYSTEM_GIF_OPTION="--disable-system-gif"
else
    SYSTEM_GIF_OPTION="--enable-system-gif"
fi

if test x${ICEDTEA_WITH_SYSTEM_GIO} = "xyes"; then
    GIO_OPTION="--enable-system-gio"
else
    GIO_OPTION="--disable-system-gio"
fi

if test x${ICEDTEA_WITH_SYSTEM_GCONF} = "xyes"; then
    GCONF_OPTION="--enable-system-gconf"
else
    GCONF_OPTION="--disable-system-gconf"
fi

if test x${ICEDTEA_WITH_SYSTEM_GTK} = "xyes"; then
    GTK_OPTION="--enable-system-gtk"
else
    GTK_OPTION="--disable-system-gtk"
fi

if test x${ICEDTEA_WITH_SYSTEM_PCSC} = "xyes"; then
    SYSTEM_PCSC_OPTION="--enable-system-pcsc"
else
    SYSTEM_PCSC_OPTION="--disable-system-pcsc"
fi

if test x${ICEDTEA_WITH_SYSTEM_SCTP} = "xyes"; then
    SYSTEM_SCTP_OPTION="--enable-system-sctp"
else
    SYSTEM_SCTP_OPTION="--disable-system-sctp"
fi

if test x${ICEDTEA_WITH_SYSTEM_CUPS} = "xyes"; then
    SYSTEM_CUPS_OPTION="--enable-system-cups"
else
    SYSTEM_CUPS_OPTION="--disable-system-cups"
fi

if test x${ICEDTEA_WITH_SUNEC} = "xyes"; then
    SUNEC_OPTION="--enable-sunec"
else
    SUNEC_OPTION="--disable-sunec"
fi

if test x${ICEDTEA_WITH_NATIVE_DEBUGINFO} = "xyes"; then
    NATIVE_DEBUGINFO_OPTION="--enable-native-debuginfo"
else
    NATIVE_DEBUGINFO_OPTION="--disable-native-debuginfo"
fi

if test x${ICEDTEA_WITH_JAVA_DEBUGINFO} = "xyes"; then
    JAVA_DEBUGINFO_OPTION="--enable-java-debuginfo"
else
    JAVA_DEBUGINFO_OPTION="--disable-java-debuginfo"
fi

if test x${ICEDTEA_WITH_SPLIT_DEBUGINFO} = "xyes"; then
    SPLIT_DEBUGINFO_OPTION="--enable-split-debuginfo"
else
    SPLIT_DEBUGINFO_OPTION="--disable-split-debuginfo"
fi

if test x${ICEDTEA_WITH_INFINALITY} = "xno"; then
    INFINALITY_OPTION="--disable-infinality"
else
    INFINALITY_OPTION="--enable-infinality"
fi

RT_JAR=${CLASSPATH_INSTALL}/share/classpath/glibj.zip

if test x${CHOST} != "x"; then
    CHOST_OPTION="--build=${CHOST}"
fi

INSTALLATION_DIR=${INSTALL_DIR}/${BUILD}

# Old
# --with-java=${GCJ_JDK_INSTALL}/bin/java ${JAVAH_OPTION} \
# --with-jar=${GCJ_JDK_INSTALL}/bin/jar --with-rmic=${GCJ_JDK_INSTALL}/bin/rmic

CONFIG_OPTS="--prefix=${INSTALLATION_DIR} --mandir=${INSTALLATION_DIR}/man \
    --with-abs-install-dir=${INSTALLATION_DIR} --with-parallel-jobs=${PARALLEL_JOBS} ${JAVAC_OPTION} \
    --with-jdk-home=${CLASSPATH_JDK_INSTALL} ${ZIP_OPTION} ${DIR_OPTION} ${RHINO_OPTION} ${DOCS_OPTION} \
    ${CACAO_OPTION} ${CACAO_ZIP_OPTION} ${SHARK_OPTION} ${VISUALVM_OPTION} ${PULSEAUDIO_OPTION} \
    ${GCJ_OPTION} ${HOTSPOT_ZIP_OPTION} ${CORBA_ZIP_OPTION} ${NASHORN_ZIP_OPTION} ${CHOST_OPTION} ${TESTS_OPTION} \
    ${JAXP_ZIP_OPTION} ${JAXWS_ZIP_OPTION} ${JDK_ZIP_OPTION} ${LANGTOOLS_ZIP_OPTION} ${NIMBUS_OPTION} \
    ${SYSTEMTAP_OPTION} ${NIMBUS_GEN_OPTION} ${XRENDER_OPTION} ${PLUGIN_OPTION} ${NEW_PLUGIN_OPTION} \
    ${NSS_OPTION} ${NIO2_OPTION} ${OPTS} ${SUNEC_OPTION} ${JAXP_DROP_ZIP_OPTION} ${JAF_DROP_ZIP_OPTION} \
    ${JAXWS_DROP_ZIP_OPTION} ${HOTSPOT_BUILD_OPTION} ${JAMVM_OPTION} ${JAMVM_ZIP_OPTION} ${LEGACY_OPTS} \
    ${SYSTEM_LCMS_OPTION} ${GIO_OPTION} ${GCONF_OPTION} ${GTK_OPTION} ${LCMS2_OPTION} ${SYSTEM_JPEG_OPTION} \
    ${SYSTEM_GIF_OPTION} ${SYSTEM_PNG_OPTION} ${SYSTEM_ZLIB_OPTION} ${SYSTEM_PCSC_OPTION} ${SYSTEM_SCTP_OPTION} \
    ${SYSTEM_CUPS_OPTION} ${NATIVE_DEBUGINFO_OPTION} ${JAVA_DEBUGINFO_OPTION} ${SPLIT_DEBUGINFO_OPTION} \
    ${INFINALITY_OPTION} --disable-downloading --with-cacerts-file=${SYSTEM_ICEDTEA7}/jre/lib/security/cacerts"

DISTCHECK_OPTS="${CONFIG_OPTS} --disable-systemtap --disable-tests --disable-systemtap-tests"

if test "${BUILD}" = "azul"; then
    export PKG_CONFIG_PATH=${AZTOOLS_INSTALL}/lib/pkgconfig
fi

echo "Passing ${CONFIG_OPTS} to configure..."

(PATH=/bin:/usr/bin ./autogen.sh &&
cd ${BUILD_DIR} &&
echo $ICEDTEA_HOME/configure ${CONFIG_OPTS} &&
CC=${CC} CXX=${CXX} CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS} LDFLAGS=${LDFLAGS} $ICEDTEA_HOME/configure ${CONFIG_OPTS}
if test "x$1" = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS="${DISTCHECK_OPTS}" make ${MAKE_OPTS} distcheck;
elif echo "$BUILD" | grep "zero6"; then
    make ${MAKE_OPTS} icedtea-against-ecj && echo COMPILED &&
    rm -rf ${INSTALLATION_DIR} &&
    mv ${BUILD_DIR}/openjdk.build-ecj${DIR}/j2sdk-image$ ${INSTALL_DIR}/${BUILD} &&
    ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk.build-ecj${DIR}/j2sdk-image &&
    echo DONE
elif echo "$BUILD" | grep "zero"; then
    make ${MAKE_OPTS} icedtea-stage1 && echo COMPILED &&
    rm -rf ${INSTALLATION_DIR} &&
    mv ${BUILD_DIR}/openjdk.build-boot${DIR}/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
    ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk.build-boot${DIR}/j2sdk-image &&
    echo DONE
else
    CFLAGS=${CFLAGS} make ${MAKE_OPTS} && echo COMPILED &&
    rm -rf ${INSTALLATION_DIR} &&
    (if [ -e ${BUILD_DIR}/openjdk.build ] ; then
      (if cat ${ICEDTEA_HOME}/Makefile.am | grep 'install\:' &> /dev/null ; then 
        mv ${BUILD_DIR}/openjdk.build${DIR}/j2sdk-image ${INSTALL_DIR}/${BUILD} ;
	cp -f ${SYSTEM_ICEDTEA7}/jre/lib/security/cacerts ${INSTALL_DIR}/${BUILD}/jre/lib/security/
      else
	make ${MAKE_OPTS} install ;
      fi) &&
      ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk.build${DIR}/j2sdk-image ;
    else
	mv ${BUILD_DIR}/openjdk/build/${OS}-${JDK_ARCH}/j2sdk-image ${INSTALL_DIR}/${BUILD} &&
	ln -s ${INSTALL_DIR}/${BUILD} ${BUILD_DIR}/openjdk/build/${OS}-${JDK_ARCH}/j2sdk-image &&
	cp -f ${SYSTEM_ICEDTEA7}/jre/lib/security/cacerts ${INSTALL_DIR}/${BUILD}/jre/lib/security/
    fi) &&
    echo DONE
fi) 2>&1 | tee ${LOG_DIR}/$(basename $0).errors
