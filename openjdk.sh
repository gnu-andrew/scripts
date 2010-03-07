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
ZERO_SUPPORT=\
    ZERO_BUILD=true \
    ZERO_LIBARCH=amd64 \
    ZERO_ARCHDEF=AMD64 \
    ARCH_DATA_MODEL=64 \
    ZERO_ENDIANNESS=little \
    ZERO_ARCHFLAG=-m64 \
    LIBFFI_LIBS="-lffi"

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
    ALT_DROPS_DIR=/home/downloads/java/drops
#    JAVAC_MAX_WARNINGS=true
#    GENSRCDIR=/tmp/generated
) 2>&1 | tee errors
