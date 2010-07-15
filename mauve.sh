#!/bin/bash

. $HOME/projects/scripts/functions

BUILD_DIR=${WORKING_DIR}/mauve

if [ -e $MAUVE_HOME ]; then
    cd $MAUVE_HOME;
    cvs update -dP;
    make distclean;
else
    cd `dirname $MAUVE_HOME`;
    cvs -z3 -d:pserver:anoncvs@sources.redhat.com:/cvs/mauve co mauve
    cd $MAUVE_HOME;
fi
autoreconf &&
create_working_dir
(
exec > $MAUVE_HOME/errors 2>&1
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
${MAUVE_HOME}/configure --with-vm=${TEST_VM} --with-ecj-jar=${ECJ_JAR} --enable-auto-compilation &&
make ${MAKE_OPTS} &&
xvfb-run ${VM} Harness gnu.testlet -vm ${TEST_VM} -showpasses -timeout 180000
)
