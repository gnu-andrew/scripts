#!/bin/bash

. $HOME/projects/scripts/functions

(rm -vf ${WORKING_DIR}/musik/musik-source-files.txt &&
rm -vf ${WORKING_DIR}/musik/stamps/musik.stamp &&
make -C ${WORKING_DIR}/musik &&
make -C ${WORKING_DIR}/musik install &&
echo DONE ) 2>&1 | tee ${MUSIK_HOME}/errors && echo DONE
cat ${MUSIK_HOME}/errors |grep 'warnings'
