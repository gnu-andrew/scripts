#!/bin/bash

. $HOME/projects/scripts/environment
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
create_working_dir
rm -rf icedtea &&
mkdir icedtea &&
cd icedtea &&
$ICEDTEA_HOME/configure --enable-parallel-jobs=9 --with-libgcj-jar=/usr/lib/jvm/gcj-jdk-4.3/jre/lib/rt.jar \
    --with-gcj-home=/usr/lib/jvm/gcj-jdk-4.3
make &> $ICEDTEA_HOME/errors && echo DONE
