#!/bin/bash

. $HOME/projects/scripts/functions

JAVA=$1
TIME=$(date +%s)
TESTPATH=$2
BUGID=$3

if test "x${JAVA}" = "x"; then
    echo "$0 <JDK> <TESTPATH> <BUGID>"
    exit 1;
fi

if test "x${TESTPATH}" = "x"; then
    echo "$0 <JDK> <TESTPATH> <BUGID>"
    exit 2;
fi

if [ ! -d jtreg ] ; then
    echo "JTreg directory missing.";
    exit 3;
fi

if [ ! -f jtreg/release ] ; then
    echo "JTreg release files missing.";
    exit 4;
fi

# Example JTreg versions:
# 8u: JTREG_VERSION=5.1 908
# 11u: JTREG_VERSION=6 0
# 17u: JTREG_VERSION=6.1 0
# 20u: JTREG_VERSION=7 0
# We convert the above to 51, 60, 61 & 70
JTREG_VERSION=$(cat jtreg/release|grep '^JTREG_VERSION'|cut -d '=' -f 2|cut -d ' ' -f 1|tr -d '.')
if [ ${JTREG_VERSION} -le 10 ] ; then
    JTREG_VERSION=$(( ${JTREG_VERSION} * 10 ))
fi

echo "JTreg version: ${JTREG_VERSION}"

# 8u can't run the newer JTreg
if [ ${JTREG_VERSION} -ge 70 ] ; then
    BOOTJAVA=${SYSTEM_JDK11}
else
    BOOTJAVA=${SYSTEM_JDK8}
fi

echo "Boot JDK: ${BOOTJAVA}"
echo "Test JDK: ${JAVA}"
echo "Test Path: ${TESTPATH}"

if [ "x$BUGID" != "x" ] ; then
    echo "Bug ID: ${BUGID}"
    BUGID="-bug:$BUGID"
fi

mkdir -p test.${TIME}/jdk/JTwork test.${TIME}/jdk/JTreport
${BOOTJAVA}/bin/java -jar jtreg/lib/jtreg.jar -v1 -ignore:quiet \
     -w:test.${TIME}/jdk/JTwork -r:test.${TIME}/jdk/JTreport \
     -jdk:$JAVA \
     $BUGID \
     ${TESTPATH} \
	    | tee test.${TIME}/tests.log
     
