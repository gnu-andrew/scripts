#!/bin/bash

. $HOME/projects/scripts/functions

(make ${MAKE_OPTS} -C ${WORKING_DIR}/dvbtools all && 
 make ${MAKE_OPTS} -C ${WORKING_DIR}/dvbtools install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
