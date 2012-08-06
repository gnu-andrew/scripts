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
ZERO_SUPPORT="
    ZERO_BUILD=true \
    ZERO_LIBARCH=${JDK_ARCH} \
    ZERO_ARCHDEF=$(echo ${JDK_ARCH}|tr a-z A-Z) \
    ARCH_DATA_MODEL=${DATA_MODEL} \
    ZERO_ENDIANNESS=${ENDIAN} \
    ZERO_ARCHFLAG=-m${DATA_MODEL} \
    LIBFFI_LIBS=-lffi"
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

# Warnings?
if test "x${OPENJDK_WITH_WARNINGS}" = "xyes"; then
     WARNINGS='JAVAC_MAX_WARNINGS=true JAVAC_WARNINGS_FATAL=true'
fi

# System libraries
if test "x${ICEDTEA_WITH_SYSTEM_LCMS}" = "xyes"; then
    SYSTEM_LCMS="USE_SYSTEM_LCMS=true LCMS_LIBS=\"$(pkg-config --libs lcms2)\" LCMS_CFLAGS=\"$(pkg-config --cflags lcms2)\""
fi

if test "x${ICEDTEA_WITH_SYSTEM_GIO}" = "xyes"; then
    SYSTEM_GIO="USE_SYSTEM_GIO=true GIO_CFLAGS=\"$(pkg-config --cflags gio-2.0)\" GIO_LIBS=\"$(pkg-config --libs gio-2.0)\""
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

if test "x$BUILD_DIR" = "x"; then
    echo "No build directory specified.";
    exit -1;
fi
(echo Building in ${WORKING_DIR}/$BUILD_DIR &&
ARGS="ALT_BOOTDIR=${BUILDVM} \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    ALT_DROPS_DIR=${DROPS_DIR} \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ANT=/usr/bin/ant \
    QUIETLY="" \
    DEBUG_BINARIES=true \
    DEBUG_CLASSFILES=true \
    DISABLE_INTREE_EC=true \
    SYSTEM_ZLIB=true \
    ${SYSTEM_LCMS} \
    ${SYSTEM_GIO} \
    USE_SYSTEM_ZLIB=true \
    USE_SYSTEM_JPEG=true \
    USE_SYSTEM_PNG=true \
    USE_SYSTEM_GIF=true \
    USE_SYSTEM_GTK=true \
    USE_SYSTEM_CUPS=true \
    USE_SYSTEM_FONTCONFIG=true \
    FT2_LIBS=\"$(pkg-config --libs freetype2)\" \
    FT2_CFLAGS=\"$(pkg-config --cflags freetype2)\" \
    ZLIB_LIBS=\"$(pkg-config --libs zlib)\" \
    ZLIB_CFLAGS=\"$(pkg-config --cflags zlib)\" \
    JPEG_LIBS=\"-ljpeg\" \
    PNG_CFLAGS=\"$(pkg-config --cflags libpng)\" \
    PNG_LIBS=\"$(pkg-config --libs libpng)\" \
    GIF_LIBS=\"-lgif\" \
    GTK_CFLAGS=\"$(pkg-config --cflags gtk+-2.0 gthread-2.0)\" \
    GTK_LIBS=\"$(pkg-config --libs gtk+-2.0 gthread-2.0)\" \
    CUPS_LIBS=\"-lcups\" \
    FONTCONFIG_CFLAGS=\"$(pkg-config --cflags fontconfig)\" \
    FONTCONFIG_LIBS=\"$(pkg-config --libs fontconfig)\" \
    NO_DOCS=true \
    COMPILE_AGAINST_SYSCALLS=true \
    OTHER_JAVACFLAGS=\"-Xmaxwarns 10000\" \
    ${ZERO_SUPPORT} \
    ${WARNINGS} STATIC_CXX=false \
    STRIP_POLICY=no_strip" && \
echo ${ARGS} && eval ANT_RESPECT_JAVA_HOME=true LANG=C make ${ARGS}
) 2>&1 | tee ${LOG_DIR}/$0-$1.errors
