#!/bin/bash

. $HOME/projects/scripts/functions

#CVS_OPTION='-Dclasspath.from-cvs=true'
PLATFORM=x86_64-linux

rm -rf ${WORKING_DIR}/jikesrvm
mkdir -p ${WORKING_DIR}/jikesrvm

ANT_OPTS="-Xmx384M" ant -Dconfig.name=prototype -Drvm.debug-symbols=true -Dhost.name=$PLATFORM \
    -Dcomponents.cache.dir=$JIKESRVM_CACHE -Ddist.dir=${WORKING_DIR}/jikesrvm ${CVS_OPTION}
