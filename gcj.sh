#!/bin/sh

. functions

# Configure to suit
GCC_DIR=$HOME/projects/classpath/gcj/sources/gcc
INSTALL_DIR=$HOME/build/gcj

if [ -e $GCC_DIR ]; then
    cd $GCC_DIR;
    ./contrib/gcc_update;
else
    cd `dirname $GCC_DIR`;
    svn co svn+ssh://gandalf@gcc.gnu.org/svn/gcc/branches/gcc-4_3-branch;
fi

create_working_dir
rm -rf gcj
mkdir gcj
cd gcj
$GCC_DIR/configure --prefix=$INSTALL_DIR --disable-multilib --enable-languages=c,c++,java \
    --enable-java-awt=gtk # --enable-java-maintainer-mode &&
make $MAKE_OPTS &> $GCC_DIR/errors &&
make install &&
echo DONE
