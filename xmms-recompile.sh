#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/xmms install &> ${XMMS_HOME}/errors && echo DONE) &
tail -f ${XMMS_HOME}/errors
