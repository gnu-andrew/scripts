#!/bin/bash

. $HOME/projects/scripts/functions

# Hack to get around broken parallel build; overwrite -j option
if test "x${MAKE_VARIABLE_WARNINGS}" != "x"; then
    MAKE_OPTS="${MAKE_VARIABLE_WARNINGS}"
fi

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
    git pull -v upstream master;
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
else
    WERROR_OPTION="--enable-Werror";
fi

if test "x${CLASSPATH_WITH_WARNINGS}" = "xno"; then
    WARNING_OPTION="--disable-warnings";
else
    WARNING_OPTION="--enable-warnings";
fi

if test "x${CLASSPATH_WITH_XMLJ}" = "xyes"; then
    XMLJ_OPTION="--enable-xmlj";
fi

if test "x${CLASSPATH_WITH_GJDOC}" = "xyes"; then
    GJDOC_OPTION="--enable-gjdoc";
else
    GJDOC_OPTION="--disable-gjdoc";
fi

CONFIG_OPTS="--enable-examples ${JAVAH_OPTION} \
    ${WERROR_OPTION} ${WARNING_OPTION} --with-ecj-jar=${ECJ_JAR} ${GSTREAMER_OPTION} \
    ${QT_OPTION} ${TOOL_OPTION} ${DOCS_OPTION} ${PLUGIN_OPTION} ${XMLJ_OPTION} ${GJDOC_OPTION}"

echo "Passing ${CONFIG_OPTS} to configure..."

(./autogen.sh &&
create_working_dir
if [ -e ${BUILD_DIR} ] ; then
    make -C ${BUILD_DIR} distclean ;
fi ;
rm -rvf ${BUILD_DIR} &&
mkdir ${BUILD_DIR} &&
cd ${BUILD_DIR} &&
JAVA="$VM" JAVAC="${CLASSPATH_JDK_INSTALL}/bin/javac" \
${CP_HOME}/configure --prefix=${INSTALL_DIR} ${CONFIG_OPTS} &&
if test x$1 = "xrelease"; then
    DISTCHECK_CONFIGURE_FLAGS=${CONFIG_OPTS} make ${MAKE_OPTS} distcheck \
	&& echo DONE;
else
    make ${MAKE_OPTS} all && \
    make ${MAKE_OPTS} dvi && \
    make ${MAKE_OPTS} install && \
    ln -sf ${CACAO_INSTALL}/lib/libjvm.so ${INSTALL_DIR}/lib
fi) 2>&1 | tee ${ERROR_LOG}
(cat ${ERROR_LOG}|grep WAR|awk '{print $4}'|sort|uniq -c|sort -n && \
 cat ${ERROR_LOG}|grep '^[0-9]* problems' \
) 2>&1 | tee $(echo ${ERROR_LOG}|sed 's#errors#stats#')
#release: rm -rf $HOME/projects/httpdocs/classpath/doc;
#release: mv ${BUILD_DIR}/doc/api/html $HOME/projects/httpdocs/classpath/doc; 
