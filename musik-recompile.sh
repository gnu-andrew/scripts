#!/bin/bash

. $HOME/projects/scripts/functions

(rm -vf ${WORKING_DIR}/musik/musik-source-files.txt &&
rm -vf ${WORKING_DIR}/musik/stamps/musik.stamp &&
make -C ${WORKING_DIR}/musik &&
make -C ${WORKING_DIR}/musik install &&
echo DONE ) 2>&1 | tee ${LOG_DIR}/$0.errors && echo DONE
cat ${LOG_DIR}/$0.errors |grep 'warnings'
