#!/bin/bash

. functions

CVS_OPTION='-Dclasspath.from-cvs=true'
PLATFORM=x86_64-linux

ANT_OPTS="-Xmx384M" ant -Dconfig.name=prototype -Drvm.debug-symbols=true -Dhost.name=$PLATFORM \
    -Dcomponents.cache.dir=$JIKESRVM_CACHE

