#!/bin/bash

. $HOME/projects/scripts/functions

# Hack to get around broken parallel build
MAKE_OPTS=

# Don't use Gentoo's dumb variable
JAVAC=

if test x$1 = "xrelease"; then
    CP_HOME=${CLASSPATH_RELEASE_HOME};
    CP_REV="classpath-0_97-release-branch";
    BUILD_DIR=${WORKING_DIR}/classpath.release;
    INSTALL_DIR=${CLASSPATH_RELEASE_INSTALL};
    if [ -e ${BUILD_DIR} ]; then
	find ${BUILD_DIR} -type f -exec chmod 640 '{}' ';';
	find ${BUILD_DIR} -type d -exec chmod 750 '{}' ';';
    fi
    ERROR_LOG="${LOG_DIR}/$0.errors.release"
else
    CP_HOME=${CLASSPATH_HOME};
    BUILD_DIR=${WORKING_DIR}/classpath;
    INSTALL_DIR=${CLASSPATH_INSTALL};
    ERROR_LOG="${LOG_DIR}/$0.errors"
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

if [ -e ${CLASSPATH_INSTALL}/bin/gjavah ] ; then
    JAVAH_OPTION="--with-javah=${CLASSPATH_INSTALL}/bin/gjavah";
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

if test "x${CLASSPATH_WITH_PLUGIN}" = "xyes"; then
    PLUGIN_OPTION="--enable-plugin";
fi

if test "x${CLASSPATH_WITH_WERROR}" = "xno"; then
    WERROR_OPTION="--disable-Werror";
fi

if test "x${CLASSPATH_WITH_XMLJ}" = "xyes"; then
    XMLJ_OPTION="--enable-xmlj";
fi

(./autogen.sh &&
create_working_dir
rm -rf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVA="$VM" \
${CP_HOME}/configure --prefix=${INSTALL_DIR} --enable-examples \
    ${JAVAH_OPTION} \
    ${WERROR_OPTION} --with-ecj-jar=${ECJ_JAR} ${GSTREAMER_OPTION} \
    ${QT_OPTION} ${TOOL_OPTION} ${DOCS_OPTION} ${PLUGIN_OPTION} ${XMLJ_OPTION} &&
if test x$1 = "xrelease"; then
    make distcheck && echo DONE;
    #rm -rf $HOME/projects/httpdocs/classpath/doc;
    #mv ${BUILD_DIR}/doc/api/html $HOME/projects/httpdocs/classpath/doc; 
else
    make ${MAKE_OPTS} all dvi install && \
    ln -sf ${CACAO_INSTALL}/lib/libjvm.so ${INSTALL_DIR}/lib
fi) 2>&1 | tee ${ERROR_LOG} && echo DONE
cat ${ERROR_LOG}|grep WAR|awk '{print $4}'|sort|uniq -c|sort -n 2>&1 | tee $(echo ${ERROR_LOG}|sed 's#errors#stats#')
cat ${ERROR_LOG}|grep 'warnings'
