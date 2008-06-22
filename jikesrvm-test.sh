#!/bin/bash

. $HOME/projects/scripts/functions

cd $JIKESRVM_HOME;
ANT_OPTS="-Xmx384M" ant -f test.xml -Drvm.debug-symbols=true -Dtest-run.name=pre-commit -Dhost.name=x86_64-linux \
    -Dcomponents.cache.dir=$JIKESRVM_CACHE
