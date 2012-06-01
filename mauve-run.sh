#!/bin/bash

. $HOME/projects/scripts/functions

BUILD_DIR=${WORKING_DIR}/mauve

if [ ! -e $BUILD_DIR/Harness.class ] ; then
    echo "Setup Mauve first.";
    exit -1;
fi

(
cd ${BUILD_DIR} &&
xvfb-run ${VM} Harness gnu.testlet -vm ${TEST_VM} -showpasses -timeout 180000 &&
echo DONE
) 2>&1 | tee $MAUVE_HOME/test_run
