#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/archiver all install && echo DONE) 2>&1 | tee ${ARCHIVER_HOME}/errors
