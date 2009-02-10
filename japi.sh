#!/bin/bash

. $HOME/projects/scripts/functions

#bin/japize as classpath packages $HOME/build/classpath/share/classpath/glibj.zip +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japize as openjdk packages $HOME/build/fake_jdk.icedtea/jre/lib/rt.jar +java $HOME/build/fake_jdk.icedtea/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japicompat -v -h -o openjdk-classpath.html openjdk.japi.gz classpath.japi.gz
#bin/japicompat -v -h -o classpath-openjdk.html classpath.japi.gz openjdk.japi.gz

#bin/japize as jikesrvm packages /home/andrew/projects/java/classpath/jikesrvm/dist/prototype_x86_64-linux/{jksvm,rvmrt}.jar +java +javax +org

if [ ! -e ${INSTALL_DIR}/japi ] ; then
  mkdir ${INSTALL_DIR}/japi;
fi

# List of excluded packages is taken from jdk/make/docs/CORE_PKGS.gmk
bin/japize as ${INSTALL_DIR}/japi/icedtea6 packages $ICEDTEA6_INSTALL/jre/lib/rt.jar +java \
    $ICEDTEA_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
    -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
    -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi
bin/japize as ${INSTALL_DIR}/japi/icedtea packages $ICEDTEA_INSTALL/jre/lib/rt.jar +java \
    $ICEDTEA_INSTALL/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources \
    -org.w3c.dom.css  -org.w3c.dom.html -org.w3c.dom.stylesheets -org.w3c.dom.traversal    \
    -org.w3c.dom.ranges -org.w3c.dom.views -org.omg.stub.javax.management.remote.rmi
