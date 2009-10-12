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

if test "x$BUILD_DIR" = "x"; then
    echo "No build directory specified.";
    exit -1;
fi
#ALT_BOOTDIR=${ICEDTEA6_INSTALL} \
(echo Building in ${WORKING_DIR}/$BUILD_DIR &&
LANG=C make ALT_BOOTDIR=/usr/lib/icedtea6 \
    ALT_OUTPUTDIR=${WORKING_DIR}/${BUILD_DIR} \
    ALT_PARALLEL_COMPILE_JOBS=$PARALLEL_JOBS \
    HOTSPOT_BUILD_JOBS=$PARALLEL_JOBS \
    ALT_JIBX_LIBS_PATH=${OPENJDK_HOME}/jibx \
    ANT=/usr/bin/ant \
    ZERO_BUILD=true \
    ZERO_LIBARCH=amd64 \
    ZERO_ARCHDEF=AMD64 \
    ZERO_BITSPERWORD=64 \
    ZERO_ENDIANNESS=little \
    ZERO_ARCHFLAG=-m64 \
    LIBFFI_LIBS="-lffi" \
    QUIETLY="" \
    DISABLE_INTREE_EC=true \
    ALT_DROP_DIR=/home/downloads/java/drops
#    GENSRCDIR=/tmp/generated
) 2>&1 | tee errors
