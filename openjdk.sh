#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=
LD_LIBRARY_PATH=
CLASSPATH=

# First argument should be directory
BUILD_DIR=$1
SOURCE_DIR=$PWD

# OpenJDK >= 10 has its version in the build machinery
# OpenJDK >= 17 stores it in a new location (JDK-8258246)
VERSION_FILE=${PWD}/make/conf/version-numbers.conf
echo -n "Checking for ${VERSION_FILE}...";
if [ ! -f ${VERSION_FILE} ] ; then
    VERSION_FILE=${PWD}/make/autoconf/version-numbers
    echo "Not found; using old version file ${VERSION_FILE}";
else
    echo "found.";
fi

if test "x$BUILD_DIR" = "x"; then
    echo "No build directory specified.";
    exit 1;
fi

# Second argument; optional forced 'recompile'
if test x"$2" = "xrecompile" ; then
    RECOMPILE=yes
else
    if [ -d ${WORKING_DIR}/${BUILD_DIR} ] ; then
	RECOMPILE=yes
    else
	RECOMPILE=no
    fi
fi

JDK_CFLAGS="${CFLAGS}"
JDK_CXXFLAGS="${CXXFLAGS}"
JDK_LDFLAGS="${LDFLAGS}"

if [ -e ${VERSION_FILE} ] ; then
    openjdk_version=$(grep '^DEFAULT_VERSION_FEATURE' ${VERSION_FILE} | cut -d '=' -f 2)
    echo "OpenJDK version: ${openjdk_version}";
    if [ ${openjdk_version} -eq 25 ] ; then
	BUILDVM=${SYSTEM_JDK24};
	IMPORTVM=${SYSTEM_JDK25};
    elif [ ${openjdk_version} -eq 24 ] ; then
	BUILDVM=${SYSTEM_JDK23};
	IMPORTVM=${SYSTEM_JDK24};
    elif [ ${openjdk_version} -eq 23 ] ; then
	BUILDVM=${SYSTEM_JDK22};
	IMPORTVM=${SYSTEM_JDK23};
    elif [ ${openjdk_version} -eq 22 ] ; then
	BUILDVM=${SYSTEM_JDK21};
	IMPORTVM=${SYSTEM_JDK22};
    elif [ ${openjdk_version} -eq 21 ] ; then
	BUILDVM=${SYSTEM_JDK20};
	IMPORTVM=${SYSTEM_JDK21};
    elif [ ${openjdk_version} -eq 20 ] ; then
	BUILDVM=${SYSTEM_JDK19};
	IMPORTVM=${SYSTEM_JDK20};
    elif [ ${openjdk_version} -eq 19 ] ; then
	BUILDVM=${SYSTEM_JDK18};
	IMPORTVM=${SYSTEM_JDK19};
    elif [ ${openjdk_version} -eq 18 ] ; then
	BUILDVM=${SYSTEM_JDK17};
	IMPORTVM=${SYSTEM_JDK18};
    elif [ ${openjdk_version} -eq 17 ] ; then
	BUILDVM=${SYSTEM_JDK16};
	IMPORTVM=${SYSTEM_JDK17};
    elif [ ${openjdk_version} -eq 16 ] ; then
	BUILDVM=${SYSTEM_JDK15};
	IMPORTVM=${SYSTEM_JDK16};
    elif [ ${openjdk_version} -eq 15 ] ; then
	BUILDVM=${SYSTEM_JDK14};
	IMPORTVM=${SYSTEM_JDK15};
    elif [ ${openjdk_version} -eq 14 ] ; then
	BUILDVM=${SYSTEM_JDK13};
	IMPORTVM=${SYSTEM_JDK14};
    elif [ ${openjdk_version} -eq 13 ] ; then
	BUILDVM=${SYSTEM_JDK12};
	IMPORTVM=${SYSTEM_JDK13};
    elif [ ${openjdk_version} -eq 12 ] ; then
	BUILDVM=${SYSTEM_JDK11};
	IMPORTVM=${SYSTEM_JDK12};
    elif [ ${openjdk_version} -eq 11 ] ; then
	BUILDVM=${SYSTEM_JDK10};
	IMPORTVM=${SYSTEM_JDK11};
    elif [ ${openjdk_version} -eq 10 ] ; then
	BUILDVM=${SYSTEM_JDK9};
	IMPORTVM=${SYSTEM_JDK10};
    else
	echo "Unrecognised OpenJDK version: ${openjdk_version}";
	exit 2;
    fi
elif [ -e ${PWD}/jdk/src/java.base/share/classes/java/lang/Object.java ] ; then
    openjdk_version=9;
    BUILDVM=${SYSTEM_JDK8};
    IMPORTVM=${SYSTEM_JDK9};
elif [ -e ${PWD}/common/autoconf ] ; then
    openjdk_version=8;
    BUILDVM=${SYSTEM_JDK7};
    IMPORTVM=${SYSTEM_JDK8};
else
    openjdk_version=7;
    BUILDVM=${SYSTEM_JDK6};
    IMPORTVM=${SYSTEM_JDK7};
    JDK_CFLAGS="${JDK_CFLAGS} -Wno-error=stringop-overflow -Wno-error=implicit-fallthrough -Wno-error=maybe-uninitialized"
fi
VERSION=OpenJDK${openjdk_version}

# Check whether this is IcedTea
if [ -f ${PWD}/.hgtags ] ; then
    echo "Mercurial repository detected; checking for IcedTea...";
    grep -q 'icedtea' ${PWD}/.hgtags;
    ICEDTEA_HG=$?;
    echo "IcedTea Mercurial: ${ICEDTEA_HG}";
fi

if [ -d ${PWD}/.git ] ; then
    echo "Git repository detected; checking for IcedTea...";
    git tag -l | grep -q 'icedtea';
    ICEDTEA_GIT=$?;
    echo "IcedTea Git: ${ICEDTEA_GIT}";
fi

if [ "x${ICEDTEA_HG}" = "x0" -o "x${ICEDTEA_GIT}" = "x0" ] ; then
    ICEDTEA=true;
else
    ICEDTEA=false;
fi

# Check whether this is our patched FIPS tree
if [ -f ${PWD}/src/java.base/linux/native/libsystemconf/systemconf.c ] ; then
    RHEL_FIPS=true;
elif [ -f ${PWD}/jdk/src/solaris/native/java/security/systemconf.c ] ; then
    RHEL_FIPS=true;
else
    RHEL_FIPS=false;
fi

if test "x${BUILDVM}" = "x"; then
    echo "No build VM available (BUILDVM=${BUILDVM}).  Exiting.";
    exit 3;
fi

echo "Building ${VERSION} using ${BUILDVM}"
echo "IcedTea: ${ICEDTEA}"
echo "RHEL FIPS: ${RHEL_FIPS}"
echo "Recompiling: ${RECOMPILE}"

# Add Zero support
if test "x${OPENJDK_WITH_ZERO}" = "xyes"; then
  ZERO_CONFIG="--with-jvm-variants=zero";
  ZERO_SUPPORT="true";
  if test "${OPENJDK_WITH_LIBFFI_BUNDLING}" = "yes"; then
      ZERO_CONFIG="${ZERO_CONFIG} --enable-libffi-bundling"
  fi
fi

#    ZERO_LIBARCH=${JDK_ARCH} \
#    ZERO_ARCHDEF=$(echo ${JDK_ARCH}|tr a-z A-Z) \
#    ARCH_DATA_MODEL=${DATA_MODEL} \
#    ZERO_ENDIANNESS=${ENDIAN} \
#    ZERO_ARCHFLAG=-m${DATA_MODEL} \
#    LIBFFI_CFLAGS=\"$(pkg-config --cflags libffi)\" \
#    LIBFFI_LIBS=\"$(pkg-config --libs libffi)\""

AZUL_SUPPORT="AVX_INCLUDE_DIR=-I/home/andrew/build/aztools/include AZNIX_API_VERSION=200"

NO_HOTSPOT="
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

JDK_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

JAXWS_ONLY="
    BUILD_CORBA=false \
    BUILD_JAXP=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

JAXP_ONLY="
    BUILD_CORBA=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

CORBA_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

HOTSPOT_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_CORBA=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM}"

CROSS_COMPILE="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_CORBA=false \
    ALT_JDK_IMPORT_PATH=${IMPORTVM} \
    ARCH_DATA_MODEL=32 \
    CROSS_COMPILE_ARCH=i686"

# Warnings?
if test "x${OPENJDK_WITH_WARNINGS}" = "xyes"; then
     WARNINGS='JAVAC_MAX_WARNINGS=true'
fi

# Hack to get around broken parallel build; overwrite -j option
MAKE_OPTS="${MAKE_OPTS} -j1"

if test "x${OPENJDK_WITH_JAVA_WERROR}" = "xyes"; then
    JAVAC_WERROR="JAVAC_WARNINGS_FATAL=true"
elif test "x${OPENJDK_WITH_JAVA_WERROR}" = "xno"; then
    JAVAC_WERROR="JAVAC_WARNINGS_FATAL=false"
fi

if test "x${OPENJDK_WITH_GCC_WERROR}" = "xyes"; then
    GCC_WERROR="WARNINGS_ARE_ERRORS=-Werror"
    WERROR="--enable-warnings-as-errors"
elif test "x${OPENJDK_WITH_GCC_WERROR}" = "xno"; then
    GCC_WERROR="WARNINGS_ARE_ERRORS="
    WERROR="--disable-warnings-as-errors"
fi

# Docs?
if test "x${OPENJDK_WITH_DOCS}" = "xno"; then
    DOCS='NO_DOCS=true'
fi

# System libraries
if test "x${OPENJDK_WITH_SYSTEM_LCMS}" = "xyes"; then
    WITH_SYSTEM_LCMS="
      USE_SYSTEM_LCMS=true SYSTEM_LCMS=true \
      LCMS_LIBS=\"$(pkg-config --libs lcms2)\" LCMS_CFLAGS=\"$(pkg-config --cflags lcms2)\""
    LCMS_CONF_OPT="--with-lcms=system"
else
    WITH_SYSTEM_LCMS="USE_SYSTEM_LCMS=false SYSTEM_LCMS=false"
    LCMS_CONF_OPT="--with-lcms=bundled"
fi

if test "x${OPENJDK_WITH_SYSTEM_GIO}" = "xyes"; then
    WITH_SYSTEM_GIO="
       USE_SYSTEM_GIO=true SYSTEM_GIO=true \
       GIO_CFLAGS=\"$(pkg-config --cflags gio-2.0)\" GIO_LIBS=\"$(pkg-config --libs gio-2.0)\""
else
    WITH_SYSTEM_GIO="SYSTEM_GIO=false"
fi
if test "x${OPENJDK_WITH_SYSTEM_GSETTINGS}" = "xyes"; then
    WITH_SYSTEM_GIO="${WITH_SYSTEM_GIO} SYSTEM_GSETTINGS=true";
else
    WITH_SYSTEM_GIO="${WITH_SYSTEM_GIO} SYSTEM_GSETTINGS=false";
fi

if test "x${OPENJDK_WITH_SYSTEM_GCONF}" = "xyes"; then
    WITH_SYSTEM_GCONF="
      USE_SYSTEM_GCONF=true SYSTEM_GCONF=true \
      GCONF_CFLAGS=\"$(pkg-config --cflags gconf-2.0)\" \
      GCONF_LIBS=\"$(pkg-config --libs gconf-2.0)\" \
      GOBJECT_CFLAGS=\"$(pkg-config --cflags gobject-2.0)\" \
      GOBJECT_LIBS=\"$(pkg-config --libs gobject-2.0)\""
else
    WITH_SYSTEM_GCONF="SYSTEM_GCONF=false"
fi

if test "x${OPENJDK_WITH_SYSTEM_ZLIB}" = "xyes"; then
    WITH_SYSTEM_ZLIB="
       SYSTEM_ZLIB=true ZLIB_LIBS=\"$(pkg-config --libs zlib)\" ZLIB_CFLAGS=\"$(pkg-config --cflags zlib)\""
    ZLIB_CONF_OPT="--with-zlib=system"
else
    WITH_SYSTEM_ZLIB="SYSTEM_ZLIB=false"
    ZLIB_CONF_OPT="--with-zlib=bundled"
fi

if test "x${OPENJDK_WITH_SYSTEM_PCSC}" = "xyes"; then
    WITH_SYSTEM_PCSC="
       SYSTEM_PCSC=true \
       PCSC_LIBS=\"$(pkg-config --libs libpcsclite)\" PCSC_CFLAGS=\"$(pkg-config --cflags libpcsclite)\""
    PCSC_CONF_OPT="--enable-system-pcsc"
else
    WITH_SYSTEM_PCSC="SYSTEM_PCSC=false"
    PCSC_CONF_OPT="--disable-system-pcsc"
fi

if test "x${OPENJDK_WITH_SYSTEM_JPEG}" = "xyes"; then
    WITH_SYSTEM_JPEG="USE_SYSTEM_JPEG=true JPEG_LIBS=\"-ljpeg\""
    JPEG_CONF_OPT="--with-libjpeg=system"
else
    WITH_SYSTEM_JPEG="USE_SYSTEM_JPEG=false SYSTEM_JPEG=false"
    JPEG_CONF_OPT="--with-libjpeg=bundled"
fi

if test "x${OPENJDK_WITH_SYSTEM_PNG}" = "xyes"; then
    WITH_SYSTEM_PNG="
       USE_SYSTEM_PNG=true SYSTEM_PNG=true \
       PNG_LIBS=\"$(pkg-config --libs libpng)\" PNG_CFLAGS=\"$(pkg-config --cflags libpng)\""
    PNG_CONF_OPT="--with-libpng=system"
else
    WITH_SYSTEM_PNG="USE_SYSTEM_PNG=false SYSTEM_PNG=false"
    PNG_CONF_OPT="--with-libpng=bundled"
fi

if test "x${OPENJDK_WITH_SYSTEM_GIF}" = "xyes"; then
    WITH_SYSTEM_GIF="USE_SYSTEM_GIF=true GIF_LIBS=\"-lgif\""
    GIF_CONF_OPT="--with-giflib=system"
else
    WITH_SYSTEM_GIF="USE_SYSTEM_GIF=false SYSTEM_GIF=false"
    GIF_CONF_OPT="--with-giflib=bundled"
fi

if test "x${OPENJDK_WITH_SYSTEM_GTK}" = "xyes"; then
    WITH_SYSTEM_GTK="
       USE_SYSTEM_GTK=true SYSTEM_GTK=true \
       GTK_LIBS=\"$(pkg-config --libs gtk+-2.0 gthread-2.0)\" GTK_CFLAGS=\"$(pkg-config --cflags gtk+-2.0 gthread-2.0)\""
else
    WITH_SYSTEM_GTK="USE_SYSTEM_GTK=false SYSTEM_GTK=false"
fi

if test "x${OPENJDK_WITH_SYSTEM_CUPS}" = "xyes"; then
    WITH_SYSTEM_CUPS="USE_SYSTEM_CUPS=true CUPS_LIBS=\"-lcups\""
else
    WITH_SYSTEM_CUPS="USE_SYSTEM_CUPS=false SYSTEM_CUPS=false"
fi

if test "x${OPENJDK_WITH_SYSTEM_FONTCONFIG}" = "xyes"; then
    WITH_SYSTEM_FONTCONFIG="
       USE_SYSTEM_FONTCONFIG=true SYSTEM_FONTCONFIG=true \
       FONTCONFIG_LIBS=\"$(pkg-config --libs fontconfig)\" FONTCONFIG_CFLAGS=\"$(pkg-config --cflags fontconfig)\""
    if test "x${OPENJDK_WITH_IMPROVED_FONT_RENDERING}" = "xyes"; then
	WITH_SYSTEM_FONTCONFIG="${WITH_SYSTEM_FONTCONFIG} IMPROVED_FONT_RENDERING=true"
	IMPROVED_FONT_RENDERING_CONF_OPT="--enable-improved-font-rendering"
    fi
else
    WITH_SYSTEM_FONTCONFIG="USE_SYSTEM_FONTCONFIG=false SYSTEM_FONTCONFIG=false"
fi

if test "x${OPENJDK_WITH_SUNEC}" = "xyes"; then
    WITH_SUNEC="
       SYSTEM_NSS=true \
       NSS_LIBS=\"$(pkg-config --libs nss-softokn)\" \
       NSS_CFLAGS=\"$(pkg-config --cflags nss-softokn)\" \
       ECC_JUST_SUITE_B=true"
else
    WITH_SUNEC="SYSTEM_NSS=false"
fi

if test "x${OPENJDK_WITH_SYSTEM_SCTP}" = "xyes"; then
    WITH_SYSTEM_SCTP="SYSTEM_SCTP=true SCTP_LIBS=\"-lsctp\""
    SCTP_CONF_OPT="--enable-system-sctp"
else
    WITH_SYSTEM_SCTP="SYSTEM_SCTP=false"
    SCTP_CONF_OPT="--disable-system-sctp"
fi

if test "x${OPENJDK_WITH_SYSTEM_KRB5}" = "xyes"; then
    WITH_KRB5="
       SYSTEM_KRB5=true \
       KRB5_LIBS=\"$(pkg-config --libs krb5)\" \
       KRB5_CFLAGS=\"$(pkg-config --cflags krb5)\""
    KRB5_CONF_OPT="--enable-system-kerberos"
else
    WITH_KRB5="SYSTEM_KRB5=false"
    KRB5_CONF_OPT="--disable-system-kerberos"
fi

if test "x${OPENJDK_WITH_FIPS_NSS}" = "xyes"; then
    WITH_FIPS_NSS="--enable-sysconf-nss";
else
    WITH_FIPS_NSS="--disable-sysconf-nss";
fi

if test "x${OPENJDK_ENABLE_DROPS}" = "xyes"; then
    DROP_ZIPS="ALT_DROPS_DIR=${DROPS_DIR}" ;
fi

if test "x${OPENJDK_WITHOUT_HOTSPOT}" = "xyes"; then
    EXTRA_OPTS="${NO_HOTSPOT}" ;
fi

if test "x${OPENJDK_WITH_DEBUG}" = "xyes"; then
    TARGET="debug_build" ;
    if test "x${OPENJDK_DEBUGLEVEL}" = "x"; then
	DEBUGLEVEL="slowdebug";
    else
	DEBUGLEVEL=${OPENJDK_DEBUGLEVEL}
    fi
else
    DEBUGLEVEL="release";
fi

# JDK-8163102 renamed --disable-headful to --enable-headless-only
if test "x${OPENJDK_WITH_HEADLESS}" = "xyes"; then
    if [ ${openjdk_version} -ge 9 ] ; then
	HEADLESS_CONF_OPT="--enable-headless-only";
    else
	HEADLESS_CONF_OPT="--disable-headful";
    fi
fi

if test "x${OPENJDK_WITH_PRECOMPILED_HEADERS}" = "xyes"; then
    HEADERS_CONF_OPT="--enable-precompiled-headers";
    HEADERS="USE_PRECOMPILED_HEADER=1";
else
    HEADERS_CONF_OPT="--disable-precompiled-headers";
    HEADERS="USE_PRECOMPILED_HEADER=0";
fi

if test "x${OPENJDK_WITH_32BIT}" = "xyes"; then
    BITS="--with-target-bits=32";
else
    BITS="--with-target-bits=64";
fi

if test "x${OPENJDK_WITH_BRANDING}" = "xyes"; then
      BRANDING_CONFIG="--with-vendor-name=${OPENJDK_BRAND_NAME} \
      --with-vendor-url=${OPENJDK_BRAND_URL} \
      --with-vendor-bug-url=${OPENJDK_BRAND_BUG_URL}"
fi

if test "x${OPENJDK_WITH_CACERTS}" = "xyes"; then
    CACERTS_CONFIG="--with-cacerts-file=${SYSTEM_CACERTS}"
    CACERTS_OPT="ALT_CACERTS_FILE=${SYSTEM_CACERTS}"
fi

if test "x${OPENJDK_WITH_JFR}" = "xyes"; then
    JFR_OPT="--enable-jfr";
else
    JFR_OPT=""; # temporarily disabled until JFR is in 8u --disable-jfr";
fi

if test "x${OPENJDK_FOR_GRAAL}" = "xyes"; then
    NEW_BUILD_TARGET="graal-builder-image";
else
    NEW_BUILD_TARGET="images";
fi

if test "x${ICEDTEA}" = "xtrue"; then
    ICEDTEA_CONF_OPTS="--with-java-debug-symbols=yes";
    if test "x${OPENJDK_WITH_FASTJAR}" = "xyes"; then \
	FASTJAR_CONF_OPT="--with-alt-jar=fastjar";
    fi
    if test "x${VERSION}" = "xOpenJDK8" ; then \
	ICEDTEA_CONF_OPTS="${ICEDTEA_CONF_OPTS} ${FASTJAR_CONF_OPT} \
           ${LCMS_CONF_OPT} ${PNG_CONF_OPT} ${JPEG_CONF_OPT} \
           ${IMPROVED_FONT_RENDERING_CONF_OPT} ${KRB5_CONF_OPT} \
           ${PCSC_CONF_OPT} ${SCTP_CONF_OPT} \
	   ${WERROR}"
    fi
fi

if test "x${RHEL_FIPS}" = "xtrue"; then
    RH_FIPS_OPTS="${WITH_FIPS_NSS}"
fi

if test "x${OPENJDK_WITH_SYSTEM_HARFBUZZ}" = "xyes"; then
    HB_CONF_OPT="--with-harfbuzz=system"
else
    HB_CONF_OPT="--with-harfbuzz=bundled"
fi

if test ${openjdk_version} -ge 9 ; then 
    OPENJDK_CONF_OPTS="${JPEG_CONF_OPT} \
           ${LCMS_CONF_OPT} ${PNG_CONF_OPT} \
           ${WERROR}"
else
    WARNINGS="${WARNINGS} ${JAVAC_WERROR} ${GCC_WERROR}"
fi

# System HarfBuzz support was added by JDK-8250894 in JDK 16
# and then backported to 11, 13 & 15.
if test ${openjdk_version} -ge 15 || test ${openjdk_version} -eq 13 || test ${openjdk_version} -eq 11; then
    echo "Building OpenJDK ${openjdk_version} so system HarfBuzz is supported"
    OPENJDK_CONF_OPTS="${OPENJDK_CONF_OPTS} ${HB_CONF_OPT}"
else
    echo "Building OpenJDK ${openjdk_version} so system HarfBuzz is not supported"
fi

if test ${openjdk_version} -ge 11 ; then
    OPENJDK_CONF_DEBUG_OPTS="--with-log=trace \
      --with-native-debug-symbols=internal";
else
    OPENJDK_MAKE_DEBUG_OPTS="STRIP_POLICY=no_strip LOG_LEVEL=debug \
      DEBUG_BINARIES=true"
fi

if test ${openjdk_version} -ge 19 ; then
    if test "x${OPENJDK_WITH_HSDIS}" != "x" -a "x${OPENJDK_WITH_HSDIS}" != "xnone"; then
	OPENJDK_HSDIS_OPTS="--with-hsdis=${OPENJDK_WITH_HSDIS}";
    fi
fi

if test "x${OPENJDK_WITH_DEVKIT}" != "x"; then
    OPENJDK_DEVKIT_OPTS="--with-devkit=${OPENJDK_WITH_DEVKIT}";
fi

if test "x${OPENJDK_WITH_ANT}" != "x"; then
    OPENJDK_ANT_HOME="${OPENJDK_WITH_ANT}";
else
    OPENJDK_ANT_HOME="/usr";
fi

if test "${OPENJDK_TOOLCHAIN}" = ""; then
    OPENJDK_TOOLCHAIN=gcc;
    echo "No toolchain selected; defaulting to gcc"
fi

if test "${OPENJDK_TOOLCHAIN}" = "gcc"; then
    if test "${SYSTEM_GCC}" = ""; then
	OPENJDK_CC=$(which gcc);
	OPENJDK_CXX=$(which g++);
	echo "gcc selected but no gcc installation configured; \
              using CC=${OPENJDK_CC} and CXX=${OPENJDK_CXX}";
    else
	OPENJDK_CC=${SYSTEM_GCC}/gcc;
	OPENJDK_CXX=${SYSTEM_GCC}/g++;
    fi
    if test "${SYSTEM_LD}" = ""; then
	OPENJDK_LD=$(which ld.bfd);
	echo "ld selected but no binary configured; using ${OPENJDK_LD}";
    else
	OPENJDK_LD=${SYSTEM_LD};
    fi
elif test "${OPENJDK_TOOLCHAIN}" = "clang"; then
    if test "${SYSTEM_LLVM}" = ""; then
	OPENJDK_CC=$(which clang);
	OPENJDK_CXX=$(which clang++);
	OPENJDK_LD=$(which ld.lld);
	echo "clang selected but no llvm installation configured; \
              using CC=${OPENJDK_CC}, CXX=${OPENJDK_CXX} and LD=${OPENJDK_LD}";
    else
	OPENJDK_CC=${SYSTEM_LLVM}/bin/clang;
	OPENJDK_CXX=${SYSTEM_LLVM}/bin/clang++;
	OPENJDK_LD=${SYSTEM_LLVM}/bin/ld;
    fi
fi

if test "x${OPENJDK_JTREG_INSTALL_DIR}" != "x"; then
    for jtreg_conf_file in make/conf/github-actions.conf make/conf/test-dependencies ; do
	if [ -f ${jtreg_conf_file} ] ; then
	    OPENJDK_JTREG_VERSION=$(grep '^JTREG_VERSION' ${jtreg_conf_file}|cut -d '=' -f 2)
	    echo "Minimum JTreg version found: ${OPENJDK_JTREG_VERSION}";
	    break;
	fi
    done
    if test "${OPENJDK_JTREG_VERSION}" != ""; then
	OPENJDK_JTREG_DIR=$(echo ${OPENJDK_JTREG_INSTALL_DIR}/jtreg-${OPENJDK_JTREG_VERSION});
	if [ -d ${OPENJDK_JTREG_DIR} ] ; then
	    echo "JTreg directory found: ${OPENJDK_JTREG_DIR}";
	    OPENJDK_JTREG_OPTS="--with-jtreg=${OPENJDK_JTREG_DIR}";
	else
	    echo "No JTreg directory ${OPENJDK_JTREG_DIR} found.";
	    exit 4;
	fi
    fi
fi

#    GENSRCDIR=/tmp/generated
#    ALT_DROPS_DIR=/home/downloads/java/drops \

CONFARGS="--enable-unlimited-crypto \
      ${ZLIB_CONF_OPT} ${GIF_CONF_OPT} ${HEADLESS_CONF_OPT} ${JFR_OPT} \
      --with-stdc++lib=dynamic --with-jobs=${PARALLEL_JOBS} ${HEADERS_CONF_OPT} \
      --with-boot-jdk=${BUILDVM} ${CACERTS_CONFIG} --with-debug-level=${DEBUGLEVEL} \
      ${ZERO_CONFIG} ${BRANDING_CONFIG} ${BITS} ${OPENJDK_CONF_OPTS} \
      ${OPENJDK_CONF_DEBUG_OPTS} ${ICEDTEA_CONF_OPTS} ${RH_FIPS_OPTS} ${OPENJDK_HSDIS_OPTS} \
      ${OPENJDK_DEVKIT_OPTS} --with-toolchain-type=${OPENJDK_TOOLCHAIN} ${OPENJDK_JTREG_OPTS}"

if test "x${VERSION}" != "xOpenJDK7" ; then \
  (echo Building in ${WORKING_DIR}/$BUILD_DIR && \
  if test x"${RECOMPILE}" != "xyes" ; then \
    rm -rf ${WORKING_DIR}/${BUILD_DIR} && \
    cd ${WORKING_DIR} && \
    mkdir ${BUILD_DIR} && \
    cd ${BUILD_DIR} && \
    echo "CC=${OPENJDK_CC} CXX=${OPENJDK_CXX} LD=${OPENJDK_LD} \
              ${SOURCE_DIR}/configure ${CONFARGS} --with-extra-cflags=\"${JDK_CFLAGS}\" \
	      --with-extra-cxxflags=\"${JDK_CXXFLAGS}\" \
	      --with-extra-ldflags=\"${JDK_LDFLAGS}\"" \
    && \
    CC=${OPENJDK_CC} CXX=${OPENJDK_CXX} LD=${OPENJDK_LD} /bin/bash \
              ${SOURCE_DIR}/configure ${CONFARGS} \
	      --with-extra-cflags="${JDK_CFLAGS}" \
	      --with-extra-cxxflags="${JDK_CXXFLAGS}" \
	      --with-extra-ldflags="${JDK_LDFLAGS}" ; \
  else \
    cd ${WORKING_DIR}/${BUILD_DIR} ; \
  fi ;
  ARGS="OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
      ${WARNINGS} ${OPENJDK_MAKE_DEBUG_OPTS} \
      JDK_DERIVATIVE_NAME=IcedTea DERIVATIVE_ID=IcedTea"
  COMMAND="ANT_RESPECT_JAVA_HOME=true LANG=C make ${ARGS} ${NEW_BUILD_TARGET}"
  echo ${COMMAND} && eval ${COMMAND} ) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
else \
  (echo Building in ${WORKING_DIR}/$BUILD_DIR && \
  cd jdk && ALT_BOOTDIR=${BUILDVM} && ZERO_BUILD=${ZERO_SUPPORT} && source make/jdk_generic_profile.sh && cd .. && \
  ARGS="ALT_BOOTDIR=${BUILDVM} \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    ${DROP_ZIPS} \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ANT_HOME=${OPENJDK_ANT_HOME} \
    QUIETLY="" \
    DEBUG_BINARIES=true \
    DEBUG_CLASSFILES=true \
    ${WITH_SYSTEM_ZLIB} \
    ${WITH_SYSTEM_LCMS} \
    ${WITH_SYSTEM_GIO} \
    ${WITH_SYSTEM_GCONF} \
    ${WITH_SYSTEM_PCSC} \
    ${WITH_SYSTEM_JPEG} \
    ${WITH_SYSTEM_PNG} \
    ${WITH_SYSTEM_GIF} \
    ${WITH_SYSTEM_GTK} \
    ${WITH_SYSTEM_CUPS} \
    ${WITH_SYSTEM_FONTCONFIG} \
    ${WITH_SYSTEM_SCTP} \
    ${WITH_SUNEC} ${WITH_KRB5} ${HEADERS} ${CACERTS_OPT} \
    FT2_LIBS=\"$(pkg-config --libs freetype2)\" \
    FT2_CFLAGS=\"$(pkg-config --cflags freetype2)\" \
    COMPILE_AGAINST_SYSCALLS=true \
    OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
    ZERO_BUILD=${ZERO_SUPPORT} STATIC_CXX=false \
    ${WARNINGS} ${EXTRA_OPTS} ${DOCS} \
    STRIP_POLICY=no_strip UNLIMITED_CRYPTO=true ENABLE_FULL_DEBUG_SYMBOLS=0 \
    NATIVE_SUPPORT_DEBUG=true CC=\"${OPENJDK_CC}\" CXX=\"${OPENJDK_CXX}\" \
    LD=\"${OPENJDK_LD}\" EXTRA_CFLAGS=\"${JDK_CFLAGS}\" EXTRA_LDFLAGS=\"${JDK_LDFLAGS}\" \
    ${TARGET}"
  echo ${ARGS} && \
  eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${MAKE_OPTS} ${ARGS} \
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
fi 

# Cross compile
#    BUILD_JAXP=false BUILD_JAXWS=false BUILD_LANGTOOLS=false BUILD_CORBA=false \
#    ALT_JDK_IMPORT_PATH=${WORKING_DIR}/${BUILD_DIR}/x86_64 CROSS_COMPILE_ARCH=i686" && \
