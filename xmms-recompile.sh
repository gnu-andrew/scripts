#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/xmms clean install && echo DONE) 2>&1 | tee ${XMMS_HOME}/errors
