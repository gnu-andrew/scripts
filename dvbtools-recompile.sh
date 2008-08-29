#!/bin/bash

. $HOME/projects/scripts/functions

(make ${MAKE_OPTS} -C ${WORKING_DIR}/dvbtools install && echo DONE) 2>&1 | tee ${DVBTOOLS_HOME}/errors
