#!/bin/bash

. $HOME/projects/scripts/functions

# Hack to get around broken parallel build
MAKE_OPTS=

# Don't use Gentoo's dumb variable
JAVAC=

if test x$1 != "x"; then
    CP_HOME=${CLASSPATH_RELEASE_HOME};
    CP_REV="classpath-0_97-release-branch";
    BUILD_DIR=${WORKING_DIR}/classpath.release;
    INSTALL_DIR=${CLASSPATH_RELEASE_INSTALL};
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR} -type f -exec chmod 640 '{}' ';';
	find ${BUILD_DIR} -type d -exec chmod 750 '{}' ';';
    fi
else
    CP_HOME=${CLASSPATH_HOME};
    BUILD_DIR=${WORKING_DIR}/classpath;
    INSTALL_DIR=${CLASSPATH_INSTALL};
fi

if [ -e $CP_HOME ]; then
    cd $CP_HOME;
    #cvs update -dP;
    make distclean;
else
    cd `dirname $CP_HOME`;
    if test x${CP_REV} != x ; then 
      revision="-r${CP_REV}";
    fi
    cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/classpath co ${revision} classpath;
    cd $CP_HOME;
fi

if test "x${CLASSPATH_WITH_GSTREAMER}" = "xyes"; then
    GSTREAMER_OPTION="--enable-gstreamer-peer";
fi

if test "x${CLASSPATH_WITH_QT}" = "xyes"; then
    QT_OPTION="--enable-qt-peer";
fi

if test "x${CLASSPATH_WITH_TOOL_WRAPPERS}" = "xyes"; then
    TOOL_OPTION="--enable-tool-wrappers";
fi

if test "x${CLASSPATH_WITH_DOCS}" = "xyes"; then
    DOCS_OPTION="--with-gjdoc";
fi

if test "x${CLASSPATH_WITH_PLUGIN}" = "xno"; then
    PLUGIN_OPTION="--disable-plugin";
fi

if test "x${CLASSPATH_WITH_WERROR}" = "xno"; then
    WERROR_OPTION="--disable-Werror";
fi

(./autogen.sh &&
create_working_dir
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVA="$VM" \
${CP_HOME}/configure --prefix=${INSTALL_DIR} --enable-examples \
    ${WERROR_OPTION} --with-ecj-jar=${ECJ_JAR} ${GSTREAMER_OPTION} \
    ${QT_OPTION} --with-javah=${GCC_INSTALL}/bin/gjavah \
    --with-jar=${GCC_INSTALL}/bin/gjar \
    ${TOOL_OPTION} ${DOCS_OPTION} ${PLUGIN_OPTION} &&
if test x$1 != "x"; then
    make distcheck && echo DONE;
    #rm -rf $HOME/projects/httpdocs/classpath/doc;
    #mv ${BUILD_DIR}/doc/api/html $HOME/projects/httpdocs/classpath/doc; 
else
    make ${MAKE_OPTS} all install;
fi && echo DONE &&
ln -sf ${CACAO_INSTALL}/lib/libjvm.so ${INSTALL_DIR}/lib) 2>&1 | tee $CLASSPATH_HOME/errors



