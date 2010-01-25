#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/trim all install && echo DONE) 2>&1 | tee ${TRIM_HOME}/errors
