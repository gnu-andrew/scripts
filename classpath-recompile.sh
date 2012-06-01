#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/classpath &&
make -C ${WORKING_DIR}/classpath install &&
echo DONE ) 2>&1 | tee ${LOG_DIR}/$0.errors && echo DONE
cat ${LOG_DIR}/$0.errors |grep 'warnings'
