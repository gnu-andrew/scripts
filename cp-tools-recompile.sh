#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/cp-tools all install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
cat ${LOG_DIR}/$0.errors |grep 'warnings'
