#!/bin/bash

. $HOME/projects/scripts/functions

make -C ${WORKING_DIR}/classpath install &> ${CLASSPATH_HOME}/errors && echo DONE
cat ${CLASSPATH_HOME}/errors |grep 'warnings'
