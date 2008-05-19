#!/bin/bash

. $HOME/projects/scripts/functions

if [ -e $JIKESRVM_HOME ]; then
    cd $JIKESRVM_HOME;
    ant real-clean;
    rm -rf components;
    svn update;
else
    cd `dirname $JIKESRVM_HOME`;
    svn co https://jikesrvm.svn.sourceforge.net/svnroot/jikesrvm/rvmroot/trunk jikesrvm;
    cd $JIKESRVM_HOME;
fi
$HOME/projects/scripts/jikesrvm.sh

