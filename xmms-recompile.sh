#!/bin/bash

. $HOME/projects/scripts/functions

(make ${MAKE_OPTS} -C ${WORKING_DIR}/xmms all &&
make ${MAKE_OPTS} -C ${WORKING_DIR}/xmms install &&
echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors

