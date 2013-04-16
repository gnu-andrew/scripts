#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=
LD_LIBRARY_PATH=
CLASSPATH=

if [ -e ${PWD}/common ] ; then
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
ZERO_SUPPORT="
    ZERO_BUILD=true \
    ZERO_LIBARCH=${JDK_ARCH} \
    ZERO_ARCHDEF=$(echo ${JDK_ARCH}|tr a-z A-Z) \
    ARCH_DATA_MODEL=${DATA_MODEL} \
    ZERO_ENDIANNESS=${ENDIAN} \
    ZERO_ARCHFLAG=-m${DATA_MODEL} \
    LIBFFI_CFLAGS=\"$(pkg-config --cflags libffi)\" \
    LIBFFI_LIBS=\"$(pkg-config --libs libffi)\""
fi

AZUL_SUPPORT="AVX_INCLUDE_DIR=-I/home/andrew/build/aztools/include AZNIX_API_VERSION=200"

NO_HOTSPOT="
    BUILD_HOTSPOT=false \
    ALT_JDK_IMPORT_PATH=${BUILDVM}"

JDK_ONLY="
    BUILD_CORBA=false \
    BUILD_JAXP=false \
    BUILD_JAXWS=false \
    BUILD_LANGTOOLS=false \
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
if test "x${MAKE_VARIABLE_WARNINGS}" != "x"; then
    MAKE_OPTS="${MAKE_VARIABLE_WARNINGS}"
fi

if test "x${OPENJDK_WITH_JAVA_WERROR}" = "xyes"; then
    JAVAC_WERROR="JAVAC_WARNINGS_FATAL=true"
fi

if test "x${OPENJDK_WITH_GCC_WERROR}" = "xyes"; then
    GCC_WERROR="COMPILER_WARNINGS_FATAL=true"
fi

# Docs?
if test "x${OPENJDK_WITH_DOCS}" = "xno"; then
    DOCS='NO_DOCS=true'
fi

# System libraries
if test "x${OPENJDK_WITH_SYSTEM_LCMS}" = "xyes"; then
    WITH_SYSTEM_LCMS="
      USE_SYSTEM_LCMS=true LCMS_LIBS=\"$(pkg-config --libs lcms2)\" LCMS_CFLAGS=\"$(pkg-config --cflags lcms2)\""
fi

if test "x${OPENJDK_WITH_SYSTEM_GIO}" = "xyes"; then
    WITH_SYSTEM_GIO="
       USE_SYSTEM_GIO=true GIO_CFLAGS=\"$(pkg-config --cflags gio-2.0)\" GIO_LIBS=\"$(pkg-config --libs gio-2.0)\""
fi

if test "x${OPENJDK_WITH_SYSTEM_ZLIB}" = "xyes"; then
    WITH_SYSTEM_ZLIB="
       USE_SYSTEM_ZLIB=true SYSTEM_ZLIB=true \
       ZLIB_LIBS=\"$(pkg-config --libs zlib)\" ZLIB_CFLAGS=\"$(pkg-config --cflags zlib)\""
fi

if test "x${OPENJDK_ENABLE_DROPS}" = "xyes"; then
    DROP_ZIPS="ALT_DROPS_DIR=${DROPS_DIR}" ;
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
  rm -rf ${WORKING_DIR}/${BUILD_DIR} && \
  cd ${WORKING_DIR} && \
  mkdir ${BUILD_DIR} && \
  cd ${BUILD_DIR} &&
  ARGS="DISABLE_INTREE_EC=true \
    OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
    ${WARNINGS} ${JAVAC_WERROR} ${GCC_WERROR} \
    ${DOCS} STRIP_POLICY=no_strip POST_STRIP_CMD= LOG=debug \
    SCTP_WERROR= DEBUG_BINARIES=true" && \
  echo ${ARGS} && \
  /bin/bash ${SOURCE_DIR}/configure \
      --enable-unlimited-crypto \
      --with-cacerts-file=${SYSTEM_ICEDTEA7}/jre/lib/security/cacerts \
      --with-zlib=system --with-stdc++lib=dynamic \
      --with-jobs=${PARALLEL_JOBS} --with-boot-jdk=${BUILDVM} \
      ${ZERO_CONFIG} && \
  eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${ARGS} all \
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
else \
  (echo Building in ${WORKING_DIR}/$BUILD_DIR && \
  cd jdk && ALT_BOOTDIR=${BUILDVM} && source make/jdk_generic_profile.sh && cd .. && \
  ARGS="ALT_BOOTDIR=${BUILDVM} \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    ${DROP_ZIPS} \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ANT=/usr/bin/ant \
    QUIETLY="" \
    DEBUG_BINARIES=true \
    DEBUG_CLASSFILES=true \
    DISABLE_INTREE_EC=true \
    ${WITH_SYSTEM_ZLIB} \
    ${WITH_SYSTEM_LCMS} \
    ${WITH_SYSTEM_GIO} \
    USE_SYSTEM_JPEG=true \
    USE_SYSTEM_PNG=true \
    USE_SYSTEM_GIF=true \
    USE_SYSTEM_GTK=true \
    USE_SYSTEM_CUPS=true \
    USE_SYSTEM_FONTCONFIG=true \
    FT2_LIBS=\"$(pkg-config --libs freetype2)\" \
    FT2_CFLAGS=\"$(pkg-config --cflags freetype2)\" \
    JPEG_LIBS=\"-ljpeg\" \
    PNG_CFLAGS=\"$(pkg-config --cflags libpng)\" \
    PNG_LIBS=\"$(pkg-config --libs libpng)\" \
    GIF_LIBS=\"-lgif\" \
    GTK_CFLAGS=\"$(pkg-config --cflags gtk+-2.0 gthread-2.0)\" \
    GTK_LIBS=\"$(pkg-config --libs gtk+-2.0 gthread-2.0)\" \
    CUPS_LIBS=\"-lcups\" \
    FONTCONFIG_CFLAGS=\"$(pkg-config --cflags fontconfig)\" \
    FONTCONFIG_LIBS=\"$(pkg-config --libs fontconfig)\" \    
    COMPILE_AGAINST_SYSCALLS=true \
    OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
    ${ZERO_SUPPORT} STATIC_CXX=false \
    ${WARNINGS} ${JAVAC_WERROR} ${GCC_WERROR} \
    ${DOCS} STRIP_POLICY=no_strip UNLIMITED_CRYPTO=true" && \
  echo ${ARGS} && \
  eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${MAKE_OPTS} ${ARGS} \
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors ; \
fi 
