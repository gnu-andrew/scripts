#!/bin/bash

JIKESRVM_DIR=$HOME/projects/classpath/jikesrvm
CACHE_DIR=$JIKESRVM_DIR/cache

ANT_OPTS="-Xmx384M" ant -f test.xml -Drvm.debug-symbols=true -Dtest-run.name=pre-commit -Dhost.name=x86_64-linux \
    -Dcomponents.cache.dir=$CACHE_DIR
