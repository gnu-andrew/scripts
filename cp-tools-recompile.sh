#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/cp-tools all install && echo DONE) 2>&1 | tee ${CLASSPATH_TOOLS_HOME}/errors
cat ${CLASSPATH_TOOLS_HOME}/errors |grep 'warnings'
