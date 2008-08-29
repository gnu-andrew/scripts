#!/bin/sh

. $HOME/projects/scripts/functions

# Configure to suit

if [ -e $GCC_HOME ]; then
    cd $GCC_HOME;
    ./contrib/gcc_update;
else
    cd `dirname $GCC_HOME`;
    svn co svn+ssh://gandalf@gcc.gnu.org/svn/gcc/branches/gcc-4_3-branch;
fi

create_working_dir
rm -rf gcj
mkdir gcj
cd gcj
(PATH=${CLASSPATH_INSTALL}/bin:$PATH \
$GCC_HOME/configure --prefix=$GCC_INSTALL --disable-multilib --enable-languages=c,c++,java \
    --enable-java-awt=gtk,xlib,qt --enable-gconf-peer --enable-gstreamer-peer \
    --enable-java-maintainer-mode &&
    make ${MAKE_OPTS} all install && echo DONE) 2>&1 | tee $GCC_HOME/errors
