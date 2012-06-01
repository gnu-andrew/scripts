#!/bin/bash

. $HOME/projects/scripts/functions

(PATH=${GCC_INSTALL}/bin:${GCJ_DEPENDENCIES}:$PATH && \
make ${MAKE_OPTS} -C ${WORKING_DIR}/gcj all && \
    make ${MAKE_OPTS} -C ${WORKING_DIR}/gcj install \
    && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
