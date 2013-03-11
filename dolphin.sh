#!/bin/sh

. $HOME/projects/scripts/functions

BUILD_DIR="${WORKING_DIR}/dolphin";
ERROR_LOG="${LOG_DIR}/$0.errors"

rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
/usr/cacao/bin/javac -d build -source 6 -target 6 `find -name '*.java'` 2>&1 | tee ${ERROR_LOG}
