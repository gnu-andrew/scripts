#!/bin/bash

. $HOME/projects/scripts/functions

BUILD_DIR=${WORKING_DIR}/mauve

if [ -e $MAUVE_HOME ]; then
    cd $MAUVE_HOME;
    cvs update -dP;
    make distclean;
    aclocal;
    autoheader -ac;
    automake;
    autoconf;
else
    cd `dirname $MAUVE_HOME`;
    cvs -z3 -d:pserver:anoncvs@sources.redhat.com:/cvs/mauve co mauve
    cd $MAUVE_HOME;
fi
autoreconf &&
create_working_dir
(
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVAC=${CLASSPATH_JDK_INSTALL}/bin/javac ${MAUVE_HOME}/configure --with-vm=${TEST_VM} --with-ecj-jar=${ECJ_JAR} --enable-auto-compilation &&
make ${MAKE_OPTS} &&
echo DONE
) 2>&1 | tee ${LOG_DIR}/$0.errors

