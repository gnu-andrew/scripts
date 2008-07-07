#!/bin/bash

. $HOME/projects/scripts/functions

make -C ${WORKING_DIR}/cp-tools install &> ${CLASSPATH_TOOLS_HOME}/errors && echo DONE
cat ${CLASSPATH_TOOLS_HOME}/errors |grep 'warnings'
