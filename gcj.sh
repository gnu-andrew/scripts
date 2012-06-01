#!/bin/sh

. $HOME/projects/scripts/functions

if [ $(echo $0|grep 'gcj-4.5') ]; then
    BUILD=gcj-4.5
    RELEASE="4.5"
else
    BUILD=gcj
fi

if test "x${RELEASE}" != "x"; then
    GCC_HOME=${GCC_HOME}-${RELEASE}
    GCC_INSTALL=${GCC_INSTALL}-${RELEASE}
fi

echo "Building ${GCC_HOME} in ${WORKING_DIR}/${BUILD} for installation in ${GCC_INSTALL}..."

# Configure to suit

if [ -e $GCC_HOME ]; then
    cd $GCC_HOME;
    #./contrib/gcc_update 2>&1 | tee $GCC_HOME/update_output;
else
    cd `dirname $GCC_HOME`;
    svn co svn+ssh://gandalf@gcc.gnu.org/svn/gcc/branches/gcc-4_3-branch;
fi
create_working_dir
rm -rf $BUILD
mkdir $BUILD
cd $BUILD
(PATH=${GCJ_DEPENDENCIES}:$PATH && \
$GCC_HOME/configure --prefix=$GCC_INSTALL --disable-multilib --enable-languages=c,c++,java \
    --enable-java-awt=gtk,xlib,qt --enable-gconf-peer --enable-gstreamer-peer --enable-gjdoc \
    --with-java-home=$GCC_INSTALL --enable-java-home --enable-java-maintainer-mode \
    --with-jvm-root-dir=$GCC_INSTALL/jdk --with-jvm-jar-dir=$GCC_INSTALL/jvm-exports \
    --with-ecj-jar=${GCJ_ECJ_JAR} &&
    make ${MAKE_OPTS} && make install && echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors
