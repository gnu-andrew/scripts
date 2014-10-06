#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=
LD_LIBRARY_PATH=
CLASSPATH=

if [ -e ${PWD}/common/autoconf ] ; then
    VERSION=OpenJDK8;
    BUILDVM=${SYSTEM_ICEDTEA7};
else
    VERSION=OpenJDK7;
    BUILDVM=${SYSTEM_ICEDTEA6};
fi
if test "x${BUILDVM}" = "x"; then
    echo "No build VM available.  Exiting.";
    exit -1;
fi
echo "Building ${VERSION} using ${BUILDVM}"

# Add Zero support
if test "x${OPENJDK_WITH_ZERO}" = "xyes"; then
ZERO_CONFIG="--with-jvm-variants=zero";
ZERO_SUPPORT="true";
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
    ALT_JDK_IMPORT_PATH=${SYSTEM_ICEDTEA8}"

JDK_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

JAXWS_ONLY="
    BUILD_CORBA=false \
    BUILD_JAXP=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

JAXP_ONLY="
    BUILD_CORBA=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

CORBA_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

HOTSPOT_ONLY="
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
    BUILD_JDK=false \
    BUILD_CORBA=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

# Warnings?
if test "x${OPENJDK_WITH_WARNINGS}" = "xyes"; then
     WARNINGS='JAVAC_MAX_WARNINGS=true'
fi

# Hack to get around broken parallel build; overwrite -j option
MAKE_OPTS="${MAKE_OPTS} -j1"

if test "x${OPENJDK_WITH_JAVA_WERROR}" = "xyes"; then
    JAVAC_WERROR="JAVAC_WARNINGS_FATAL=true"
else
    JAVAC_WERROR="JAVAC_WARNINGS_FATAL=false"
fi

if test "x${OPENJDK_WITH_GCC_WERROR}" = "xyes"; then
    GCC_WERROR="COMPILER_WARNINGS_FATAL=true"
else
    GCC_WERROR="COMPILER_WARNINGS_FATAL=false"
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
    WITH_SYSTEM_GIO="USE_SYSTEM_GIO=false SYSTEM_GIO=false"
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
else
    WITH_SYSTEM_PCSC="SYSTEM_PCSC=false"
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
       FONTCONFIG_LIBS=\"$(pkg-config --libs fontconfig)\" FONTCONFIG_CFLAGS=\"$(pkg-config --cflags fontconfig)\" \
       INFINALITY_SUPPORT=true"
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
    WITH_SUNEC="SYSTEM_NSS=false DISABLE_INTREE_EC=true"
fi

if test "x${OPENJDK_ENABLE_DROPS}" = "xyes"; then
    DROP_ZIPS="ALT_DROPS_DIR=${DROPS_DIR}" ;
fi

if test "x${OPENJDK_WITHOUT_HOTSPOT}" = "xyes"; then
    EXTRA_OPTS="${NO_HOTSPOT}" ;
fi

if test "x${OPENJDK_WITH_DEBUG}" = "xyes"; then
    TARGET="debug_build" ;
fi

#    GENSRCDIR=/tmp/generated
#    USE_SYSTEM_GCONF=true \
#    GCONF_CFLAGS="$(pkg-config --cflags gconf-2.0)" \
#    GCONF_LIBS="$(pkg-config --libs gconf-2.0)" \
#    GOBJECT_CFLAGS="$(pkg-config --cflags gobject-2.0)" \
#    GOBJECT_LIBS="$(pkg-config --libs gobject-2.0)" \
#    ALT_DROPS_DIR=/home/downloads/java/drops \

# First argument should be directory
BUILD_DIR=$1
SOURCE_DIR=$PWD

if test "x$BUILD_DIR" = "x"; then
    echo "No build directory specified.";
    exit -1;
fi

if test "x${VERSION}" = "xOpenJDK8"; then \
  (echo Building in ${WORKING_DIR}/$BUILD_DIR && \
  if test x"$2" != "xrecompile" ; then \
    rm -rf ${WORKING_DIR}/${BUILD_DIR} && \
    cd ${WORKING_DIR} && \
    mkdir ${BUILD_DIR} && \
    cd ${BUILD_DIR} && \
    /bin/bash ${SOURCE_DIR}/configure \
      --enable-unlimited-crypto \
      --with-cacerts-file=${SYSTEM_ICEDTEA7}/jre/lib/security/cacerts \
      ${ZLIB_CONF_OPT} ${GIF_CONF_OPT} ${LCMS_CONF_OPT} ${PNG_CONF_OPT} \
      --with-stdc++lib=dynamic --with-jobs=${PARALLEL_JOBS} ${JPEG_CONF_OPT} \
      --with-boot-jdk=${BUILDVM} --with-alt-jar=fastjar ${ZERO_CONFIG} ; \
  else \
    cd ${WORKING_DIR}/${BUILD_DIR} ; \
  fi ;
  ARGS="DISABLE_INTREE_EC=true \
      OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
      ${WARNINGS} ${JAVAC_WERROR} ${GCC_WERROR} \
      STRIP_POLICY=no_strip POST_STRIP_CMD= LOG=debug \
      DEBUG_BINARIES=true JDK_DERIVATIVE_NAME=IcedTea \
      DERIVATIVE_ID=IcedTea" && \
  echo ${ARGS} && \
  eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${ARGS} images \
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
else \
  (echo Building in ${WORKING_DIR}/$BUILD_DIR && \
  cd jdk && ALT_BOOTDIR=${BUILDVM} && ZERO_BUILD=${ZERO_SUPPORT} && source make/jdk_generic_profile.sh && cd .. && \
  ARGS="ALT_BOOTDIR=${BUILDVM} \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    ${DROP_ZIPS} \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ANT=/usr/bin/ant \
    QUIETLY="" \
    DEBUG_BINARIES=true \
    DEBUG_CLASSFILES=true \
    ${WITH_SYSTEM_ZLIB} \
    ${WITH_SYSTEM_LCMS} \
    ${WITH_SYSTEM_GIO} \
    ${WITH_SYSTEM_PCSC} \
    ${WITH_SYSTEM_JPEG} \
    ${WITH_SYSTEM_PNG} \
    ${WITH_SYSTEM_GIF} \
    ${WITH_SYSTEM_GTK} \
    ${WITH_SYSTEM_CUPS} \
    ${WITH_SYSTEM_FONTCONFIG} \
    ${WITH_SUNEC} \
    FT2_LIBS=\"$(pkg-config --libs freetype2)\" \
    FT2_CFLAGS=\"$(pkg-config --cflags freetype2)\" \
    COMPILE_AGAINST_SYSCALLS=true \
    OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
    ZERO_BUILD=${ZERO_SUPPORT} STATIC_CXX=false \
    ${WARNINGS} ${JAVAC_WERROR} ${GCC_WERROR} ${EXTRA_OPTS} EXTRA_CFLAGS=\"${CFLAGS}\" \
    ${DOCS} STRIP_POLICY=no_strip UNLIMITED_CRYPTO=true CC=\"/usr/bin/gcc\" CXX=\"/usr/bin/g++\" \
    ENABLE_FULL_DEBUG_SYMBOLS=0 ${TARGET}"
  echo ${ARGS} && \
  eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${MAKE_OPTS} ${ARGS} \
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
fi 

# Cross compile
#    BUILD_JAXP=false BUILD_JAXWS=false BUILD_LANGTOOLS=false BUILD_CORBA=false \
#    ALT_JDK_IMPORT_PATH=${WORKING_DIR}/${BUILD_DIR}/x86_64 CROSS_COMPILE_ARCH=i686" && \
