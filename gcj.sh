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
$GCC_HOME/configure --prefix=$GCC_INSTALL --disable-multilib --enable-languages=c,c++,java \
    --enable-java-awt=gtk # --enable-java-maintainer-mode &&
make $MAKE_OPTS &> $GCC_HOME/errors &&
make install &&
echo DONE
