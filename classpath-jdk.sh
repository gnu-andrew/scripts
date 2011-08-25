#!/bin/bash

. $HOME/projects/scripts/functions

VM=$1

if test "x$VM" = "x"; then
    echo "No VM specified.";
    exit -1;
fi

VM_BINARY=$(which ${VM})
JDK_DIR=${INSTALL_DIR}/${VM}-jdk
CLASSPATH_RT=${CLASSPATH_INSTALL}/share/classpath/glibj.zip
CLASSPATH_TOOLS=${CLASSPATH_INSTALL}/share/classpath/tools.zip

gen_script()
{
    FILE=$1
    CLASS=$2
    JRE=$3
    EXTRA_JARS=$4

    if test "x$JRE" = "xjre"; then
	FILE_PATH=${JDK_DIR}/jre/bin/${FILE}
	ln -s ${FILE_PATH} ${JDK_DIR}/bin/${FILE}
    else
	FILE_PATH=${JDK_DIR}/bin/${FILE}
    fi
    echo "Creating $FILE script"
    echo "#!/bin/bash" > ${FILE_PATH}
    echo "${VM_BINARY} -classpath ${CLASSPATH_TOOLS}${EXTRA_JARS} ${CLASS} \"\$@\"" \
	>> ${FILE_PATH}
    chmod +x ${FILE_PATH}
}

echo Setting up ${VM_BINARY} in ${JDK_DIR}

rm -rf ${JDK_DIR}

mkdir -pv ${JDK_DIR}/bin
mkdir -pv ${JDK_DIR}/jre/bin
mkdir -pv ${JDK_DIR}/lib

ln -sv ${VM_BINARY} ${JDK_DIR}/jre/bin/java
ln -sv ${JDK_DIR}/jre/bin/java ${JDK_DIR}/bin/java

gen_script jar gnu.classpath.tools.jar.Main
gen_script javadoc gnu.classpath.tools.gjdoc.Main "" ":${ANTLR_JAR}"
gen_script rmic gnu.classpath.tools.rmic.Main
gen_script javah gnu.classpath.tools.javah.Main
gen_script javap gnu.classpath.tools.javap.Main
gen_script jarsigner gnu.classpath.tools.jarsigner.Main
gen_script serialver gnu.classpath.tools.serialver.Main
gen_script rmiregistry gnu.classpath.tools.rmiregistry.Main jre
gen_script keytool gnu.classpath.tools.keytool.Main jre
gen_script native2ascii gnu.classpath.tools.native2ascii.Main jre
gen_script orbd gnu.classpath.tools.orbd.Main jre
gen_script rmid gnu.classpath.tools.rmid.Main jre
gen_script tnameserv gnu.classpath.tools.tnameserv.Main jre

mkdir -pv ${JDK_DIR}/jre/lib/${JDK_ARCH}/client

ln -sv ${CLASSPATH_RT} ${JDK_DIR}/jre/lib/rt.jar
ln -sv ${CLASSPATH_TOOLS} ${JDK_DIR}/lib/tools.jar
ln -sv ${CLASSPATH_INSTALL}/include ${JDK_DIR}/include

echo "Creating javac script"
echo "#!/bin/bash" > ${JDK_DIR}/bin/javac
echo "${VM_BINARY} -classpath ${ECJ_JAR} org.eclipse.jdt.internal.compiler.batch.Main \"\$@\"" \
    >> ${JDK_DIR}/bin/javac
chmod +x ${JDK_DIR}/bin/javac

