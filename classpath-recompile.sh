#!/bin/bash

. $HOME/projects/scripts/functions

(make -C ${WORKING_DIR}/classpath &&
make -C ${WORKING_DIR}/classpath install &&
echo DONE ) 2>&1 | tee ${LOG_DIR}/$0.errors && echo DONE && 
cat ${LOG_DIR}/$0.errors|grep WAR|awk '{print $4}'|sort|uniq -c|sort -n 2>&1 | tee ${LOG_DIR}/$0.stats
cat ${LOG_DIR}/$0.errors|grep 'warnings'
