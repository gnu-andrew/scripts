#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=
LD_LIBRARY_PATH=
CLASSPATH=

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

# Warnings?
if test "x${OPENJDK_WITH_WARNINGS}" = "xyes"; then
     WARNINGS="JAVAC_MAX_WARNINGS=true"
fi

#    GENSRCDIR=/tmp/generated

# First argument should be directory
BUILD_DIR=$1

if test "x$BUILD_DIR" = "x"; then
    echo "No build directory specified.";
    exit -1;
fi
(echo Building in ${WORKING_DIR}/$BUILD_DIR &&
LANG=C make ALT_BOOTDIR=${SYSTEM_ICEDTEA6} \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ANT=/usr/bin/ant \
    QUIETLY="" \
    DISABLE_INTREE_EC=true \
    ALT_DROPS_DIR=/home/downloads/java/drops \
    ${ZERO_SUPPORT} ${AZUL_SUPPORT} \
    ${WARNINGS} \
) 2>&1 | tee errors
