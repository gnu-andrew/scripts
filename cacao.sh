#!/bin/sh

. $HOME/projects/scripts/functions

# Configure to suit

if [ -e $CACAO_HOME ]; then
    cd $CACAO_HOME;
    make distclean;
    hg pull -u;
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
    --enable-statistics &&
make $MAKE_OPTS && make install) 2>&1 | tee $CACAO_HOME/errors && echo DONE
