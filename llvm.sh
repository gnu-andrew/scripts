#!/bin/bash

. $HOME/projects/scripts/functions

if [ ! -e $LLVM_HOME ]; then
    cd `dirname $LLVM_HOME`;
    svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm;
    cd $LLVM_HOME;
else
    cd $LLVM_HOME;
    svn update;
fi
create_working_dir
rm -rf llvm
mkdir llvm
cd llvm
$LLVM_HOME/configure --prefix=$LLVM_INSTALL --enable-pic --with-pic
(make ${MAKE_OPTS} all check install && echo DONE) 2>&1 | tee $LLVM_HOME/errors

 
