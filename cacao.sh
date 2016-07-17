#!/bin/sh

. $HOME/projects/scripts/functions

# Configure to suit

if [ -e $CACAO_HOME ]; then
    cd $CACAO_HOME;
    make distclean;
    hg pull -b default -u;
else
    cd `dirname $CACAO_HOME`;
    hg clone http://mips.complang.tuwien.ac.at/hg/cacao/;
    cd $CACAO_HOME;
fi
PATH=/bin:/usr/bin ./autogen.sh
create_working_dir
rm -rf cacao
(mkdir cacao &&
cd cacao &&
$CACAO_HOME/configure --prefix=$CACAO_INSTALL --with-java-runtime-library-prefix=$CLASSPATH_INSTALL \
    --enable-statistics --disable-test-dependency-checks &&
make $MAKE_OPTS && make install && \
rm -vf ${CACAO_INSTALL}/bin/java && \
/usr/sbin/paxctl-ng -v -m ${CACAO_INSTALL}/bin/cacao && \
echo DONE) 2>&1 | tee ${LOG_DIR}/$0.errors 
