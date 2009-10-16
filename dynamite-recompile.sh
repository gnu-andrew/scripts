#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/dynamite install && echo DONE) 2>&1|tee ${DYNAMITE_HOME}/errors
cat ${DYNAMITE_HOME}/errors |grep 'warnings'
