#!/bin/bash

. $HOME/projects/scripts/functions

#bin/japize as classpath packages $HOME/build/classpath/share/classpath/glibj.zip +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japize as openjdk packages $HOME/build/fake_jdk.icedtea/jre/lib/rt.jar +java $HOME/build/fake_jdk.icedtea/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japicompat -v -h -o openjdk-classpath.html openjdk.japi.gz classpath.japi.gz
#bin/japicompat -v -h -o classpath-openjdk.html classpath.japi.gz openjdk.japi.gz

#bin/japize as jikesrvm packages /home/andrew/projects/java/classpath/jikesrvm/dist/prototype_x86_64-linux/{jksvm,rvmrt}.jar +java +javax +org

if [ ! -e ${JAPI_INSTALL} ] ; then
  mkdir ${JAPI_INSTALL};
fi

# List of excluded packages is taken from jdk/make/docs/CORE_PKGS.gmk
${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6-1.10 packages $SYSTEM_ICEDTEA6/jre/lib/rt.jar +java \
    $SYSTEM_ICEDTEA6/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
    -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
    -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi -org.classpath
${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6 packages $ICEDTEA6_INSTALL/jre/lib/rt.jar +java \
    $ICEDTEA6_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
    -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
    -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi -org.classpath
${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea7 packages $ICEDTEA7_INSTALL/jre/lib/rt.jar +java \
    $ICEDTEA7_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
    -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
    -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea6-1.9-head.html \
    ${JAPI_INSTALL}/icedtea6-1.9.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz
${JAPI_HOME}/bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea6-icedtea7.html \
    ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz

bin/japize as ${JAPI_INSTALL}/classpath packages $HOME/build/classpath/share/classpath/glibj.zip +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea6-classpath.html ${JAPI_INSTALL}/icedtea6.japi.gz ${JAPI_INSTALL}/classpath.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea6.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea6.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/icedtea7-classpath.html ${JAPI_INSTALL}/icedtea7.japi.gz ${JAPI_INSTALL}/classpath.japi.gz
bin/japicompat -v -h -o ${JAPI_INSTALL}/classpath-icedtea7.html ${JAPI_INSTALL}/classpath.japi.gz ${JAPI_INSTALL}/icedtea7.japi.gz

${JAPI_HOME}/bin/japize as ${JAPI_INSTALL}/icedtea6-jpeg packages $ICEDTEA6_INSTALL/jre/lib/rt.jar +com.sun.image.codec.jpeg +sun.awt.image.codec

