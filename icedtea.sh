#!/bin/bash

. $HOME/projects/scripts/functions

# Don't use Gentoo's dumb variables
JAVAC=
JAVACFLAGS=
JAVA_HOME=
JDK_HOME=

if [ -e $ICEDTEA_HOME ]; then
    cd $ICEDTEA_HOME;
    hg pull -u;
    make distclean;
else
    cd `dirname $ICEDTEA_HOME`;
    hg clone http://icedtea.classpath.org/hg/icedtea;
    cd $ICEDTEA_HOME;
fi
cd $WORKING_DIR/icedtea &&
$ICEDTEA_HOME/configure --with-parallel-jobs=9 --with-libgcj-jar=/usr/lib/jvm/gcj-jdk-4.3/jre/lib/rt.jar \
    --with-gcj-home=/usr/lib/jvm/gcj-jdk-4.3
make &> $ICEDTEA_HOME/errors && echo DONE
