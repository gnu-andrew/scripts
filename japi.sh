#!/bin/bash

. $HOME/projects/scripts/functions

#bin/japize as jikesrvm packages /home/andrew/projects/java/classpath/jikesrvm/dist/prototype_x86_64-linux/{jksvm,rvmrt}.jar +java +javax +org

if [ ! -e ${JAPI_INSTALL} ] ; then
  mkdir ${JAPI_INSTALL};
fi

# List of excluded packages is taken from jdk/make/docs/CORE_PKGS.gmk
if test "x${REBUILD_ICEDTEA_JAPI}" = "xyes"; then
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6 packages ${ICEDTEA6_INSTALL}/jre/lib/rt.jar +java \
      $ICEDTEA6_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
      -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
      -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi -org.classpath
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea7 packages ${ICEDTEA7_INSTALL}/jre/lib/rt.jar +java \
      $ICEDTEA7_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
      -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
      -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea6-icedtea7.html \
      ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz
  ${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea7-icedtea6.html \
      ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz
  ${JAPI_HOME}/bin/japicompat -v -j -o ${JAPI_INSTALL}/ignore-6-7.japio \
      ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz
fi

bin/japize as ${JAPI_INSTALL}/classpath packages $HOME/build/classpath/share/classpath/glibj.zip +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
bin/japicompat -v -h -i ${JAPI_INSTALL}/ignore-6-7.japio -o ${JAPI_INSTALL}/icedtea6-classpath.html ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/classpath.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea6.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea7-classpath.html ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/classpath.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea7.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz

if test "x${JPEG_JAPI_COMPARISON}" = "xyes"; then
  ${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6-jpeg packages ${ICEDTEA6_INSTALL}/jre/lib/rt.jar +com.sun.image.codec.jpeg +sun.awt.image.codec
fi

