#!/bin/bash

. $HOME/projects/scripts/functions

#bin/japize as jikesrvm packages /home/andrew/projects/java/classpath/jikesrvm/dist/prototype_x86_64-linux/{jksvm,rvmrt}.jar +java +javax +org

if [ ! -e ${JAPI_INSTALL} ] ; then
  mkdir ${JAPI_INSTALL};
fi

# List of excluded packages is taken from jdk/make/docs/CORE_PKGS.gmk
if test "x${REBUILD_ICEDTEA_JAPI}" = "xyes"; then
  (${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6 packages ${SYSTEM_ICEDTEA6}/jre/lib/rt.jar +java \
      ${SYSTEM_ICEDTEA6}/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
      -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
      -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi -org.classpath ; \
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea7 packages ${SYSTEM_ICEDTEA7}/jre/lib/rt.jar +java \
      ${SYSTEM_ICEDTEA8}/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
      -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
      -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi ; \
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea8 packages ${SYSTEM_ICEDTEA8}/jre/lib/rt.jar +java \
      ${SYSTEM_ICEDTEA8}/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
      -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
      -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi ; \
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/javadoc6 packages ${SYSTEM_ICEDTEA6}/jre/lib/rt.jar ${SYSTEM_ICEDTEA6}/lib/tools.jar \
      +com.sun.javadoc +com.sun.tools.doclets -com.sun.tools.doclets.internal -com.sun.tools.doclets.formats -com.sun.tools.doclets.standard ; \
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/javadoc7 packages ${SYSTEM_ICEDTEA7}/jre/lib/rt.jar ${SYSTEM_ICEDTEA7}/lib/tools.jar \
      +com.sun.javadoc +com.sun.tools.doclets -com.sun.tools.doclets.internal -com.sun.tools.doclets.formats -com.sun.tools.doclets.standard ; \
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/javadoc8 packages ${SYSTEM_ICEDTEA8}/jre/lib/rt.jar ${SYSTEM_ICEDTEA8}/lib/tools.jar \
      +com.sun.javadoc +com.sun.tools.doclets -com.sun.tools.doclets.internal -com.sun.tools.doclets.formats -com.sun.tools.doclets.standard ; \
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-5-6.japio \
      ${JAPI_INSTALL}/ibmjdk15.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea6-icedtea7.html \
      ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea7-icedtea6.html \
      ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-6-7.japio \
      ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea7-icedtea8.html \
      ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/icedtea8.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea8-icedtea7.html \
      ${JAPI_INSTALL}/icedtea8.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-7-8.japio \
      ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/icedtea8.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc6-javadoc7.html \
      ${JAPI_INSTALL}/javadoc6.japi.gz ${JAPI_INSTALL}/javadoc7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc7-javadoc6.html \
      ${JAPI_INSTALL}/javadoc7.japi.gz ${JAPI_INSTALL}/javadoc6.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-6-7-javadoc.japio \
      ${JAPI_INSTALL}/javadoc6.japi.gz ${JAPI_INSTALL}/javadoc7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc7-javadoc8.html \
      ${JAPI_INSTALL}/javadoc7.japi.gz ${JAPI_INSTALL}/javadoc8.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc8-javadoc7.html \
      ${JAPI_INSTALL}/javadoc8.japi.gz ${JAPI_INSTALL}/javadoc7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-7-8-javadoc.japio \
      ${JAPI_INSTALL}/javadoc7.japi.gz ${JAPI_INSTALL}/javadoc8.japi.gz ) \
  2>&1 | tee ${LOG_DIR}/japi-icedtea.errors && echo DONE
fi

if test "x${REBUILD_LIBGCJ_JAPI}" = "xyes"; then
  (${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION} packages ${SYSTEM_GCJ}/jre/lib/rt.jar \
      +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources ; \
  ${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-5-6.japio -o ${JAPI_INSTALL}/ibmjdk15-libgcj-${SYSTEM_GCJ_VERSION}.html ${JAPI_INSTALL}/ibmjdk15.japi.gz ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}-ibmjdk15.html ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ${JAPI_INSTALL}/ibmjdk15.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-6-7.japio -o ${JAPI_INSTALL}/icedtea6-libgcj-${SYSTEM_GCJ_VERSION}.html ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}-icedtea6.html ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-7-8.japio -o ${JAPI_INSTALL}/icedtea7-libgcj-${SYSTEM_GCJ_VERSION}.html ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}-icedtea7.html ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea8-libgcj-${SYSTEM_GCJ_VERSION}.html ${JAPI_INSTALL}/icedtea8.japi.gz ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ; \
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}-icedtea8.html ${JAPI_INSTALL}/libgcj-${SYSTEM_GCJ_VERSION}.japi.gz ${JAPI_INSTALL}/icedtea8.japi.gz ; \
  ) 2>&1 | tee ${LOG_DIR}/japi-libgcj.errors && echo DONE ;
fi

(${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/classpath packages $HOME/build/classpath/share/classpath/glibj.zip \
    +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources ; \
${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/gjdoc packages $HOME/build/classpath/share/classpath/glibj.zip $HOME/build/classpath/share/classpath/tools.zip \
    +com.sun.javadoc +com.sun.tools.doclets ) 2>&1 | tee ${LOG_DIR}/japi-classpath.errors && echo DONE

(${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-5-6.japio -o ${JAPI_INSTALL}/ibmjdk15-classpath.html ${JAPI_INSTALL}/ibmjdk15.japi.gz ${JAPI_INSTALL}/classpath.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-ibmjdk15.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/ibmjdk15.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-6-7.japio -o ${JAPI_INSTALL}/icedtea6-classpath.html ${JAPI_INSTALL}/icedtea6.japi.gz \
    ${JAPI_INSTALL}/classpath.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea6.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-7-8.japio -o ${JAPI_INSTALL}/icedtea7-classpath.html ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/classpath.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea7.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea8-classpath.html ${JAPI_INSTALL}/icedtea8.japi.gz ${JAPI_INSTALL}/classpath.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea8.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea8.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-6-7-javadoc.japio -o ${JAPI_INSTALL}/gjdoc-javadoc6.html ${JAPI_INSTALL}/gjdoc.japi.gz \
    ${JAPI_INSTALL}/javadoc6.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc6-gjdoc.html ${JAPI_INSTALL}/javadoc6.japi.gz ${JAPI_INSTALL}/gjdoc.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-7-8-javadoc.japio -o ${JAPI_INSTALL}/gjdoc-javadoc7.html ${JAPI_INSTALL}/gjdoc.japi.gz ${JAPI_INSTALL}/javadoc7.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc7-gjdoc.html ${JAPI_INSTALL}/javadoc7.japi.gz ${JAPI_INSTALL}/gjdoc.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/gjdoc-javadoc8.html ${JAPI_INSTALL}/gjdoc.japi.gz ${JAPI_INSTALL}/javadoc8.japi.gz ; \
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/javadoc8-gjdoc.html ${JAPI_INSTALL}/javadoc8.japi.gz ${JAPI_INSTALL}/gjdoc.japi.gz ; \
) 2>&1 | tee ${LOG_DIR}/japi-compare.errors && echo DONE

if test "x${JPEG_JAPI_COMPARISON}" = "xyes"; then
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6-jpeg packages ${ICEDTEA6_INSTALL}/jre/lib/rt.jar +com.sun.image.codec.jpeg +sun.awt.image.codec
fi

