#!/bin/bash

. $HOME/projects/scripts/functions

(make ${MAKE_OPTS} -C ${WORKING_DIR}/gcj all && \
    make ${MAKE_OPTS} -C ${WORKING_DIR}/gcj install \
    && echo DONE) 2>&1 | tee $GCC_HOME/errors
