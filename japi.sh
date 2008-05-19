#!/bin/bash

ICEDTEA6_HOME=/opt/icedtea6-1.1

#bin/japize as classpath packages $HOME/build/classpath/share/classpath/glibj.zip +java +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japize as openjdk packages $HOME/build/fake_jdk.icedtea/jre/lib/rt.jar +java $HOME/build/fake_jdk.icedtea/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
#bin/japicompat -v -h -o openjdk-classpath.html openjdk.japi.gz classpath.japi.gz
#bin/japicompat -v -h -o classpath-openjdk.html classpath.japi.gz openjdk.japi.gz

#bin/japize as jikesrvm packages /home/andrew/projects/java/classpath/jikesrvm/dist/prototype_x86_64-linux/{jksvm,rvmrt}.jar +java +javax +org

bin/japize as openjdk6-b08 packages $ICEDTEA6_HOME/jre/lib/rt.jar +java \
    $ICEDTEA6_HOME/jre/lib/jce.jar +javax +org -java.awt.dnd.peer -java.awt.peer -java.text.resources
