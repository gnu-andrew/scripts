#!/bin/bash

. $HOME/projects/scripts/functions

make -C ${WORKING_DIR}/classpath install 2>&1 | tee ${CLASSPATH_HOME}/errors && echo DONE
cat ${CLASSPATH_HOME}/errors |grep 'warnings'
