#!/bin/sh

DIR_8U=${1}
DIR_TZDATA=${2}
COPYRIGHT_HEADER=${3}

WORKING_DIR=$(dirname "${0}")

LOC_8U="jdk/make/data/tzdata";

if test "x${DIR_8U}" = "x"; then
    echo "No 8u tzdata tree found.";
    echo "${0} <DIR_8U> <DIR_TZDATA> <COPYRIGHT_HEADER>";
    exit 1;
fi

echo "8u tree: ${DIR_8U}"
if [ -f ${DIR_8U}/africa ] ; then
    echo "Found ${DIR_8U}/africa";
else
    echo "Could not find africa tzdata in ${DIR_8U}";
    DIR_8U="${DIR_8U}/${LOC_8U}";
    echo "Trying ${DIR_8U}";
    if [ -f ${DIR_8U}/africa ] ; then
	echo "Found ${DIR_8U}/africa";
    else
	echo "Could not find tzdata there either.";
	exit 2;
    fi
fi
echo;

if test "x${DIR_TZDATA}" = "x"; then
    echo "No rearguard tzdata tree found.";
    echo "${0} <DIR_8U> <DIR_TZDATA> <COPYRIGHT_HEADER>";
    exit 3;
fi

echo "Rearguard tree: ${DIR_TZDATA}"
if [ -f ${DIR_TZDATA}/africa ] ; then
    echo "Found ${DIR_TZDATA}/africa";
else
    echo "Could not find rearguard africa tzdata in ${DIR_TZDATA}";
    exit 4;
fi
echo;

if test "x${COPYRIGHT_HEADER}" = "x"; then
    echo "No copyright header found.";
    COPYRIGHT_HEADER="${WORKING_DIR}/tzdata_copyright_header";
    echo "Trying ${COPYRIGHT_HEADER}";
fi

echo "Copyright header: ${COPYRIGHT_HEADER}";
if [ -f ${COPYRIGHT_HEADER} ] ; then
    echo "Found copyright header ${COPYRIGHT_HEADER}";
else
    echo "${COPYRIGHT_HEADER} is not a valid file";
    echo "${0} <DIR_8U> <DIR_TZDATA> <COPYRIGHT_HEADER>";
    exit 5;
fi
echo;

if test "x$TMPDIR" = "x"; then
    TMPDIR=/tmp
fi

for file in ${DIR_8U}/*; do
    zone=$(basename ${file});
    if [ -e ${DIR_TZDATA}/${zone} ] ; then
	echo "Checking ${zone}...";
	cat ${COPYRIGHT_HEADER} ${DIR_TZDATA}/${zone} > ${TMPDIR}/${zone}.$$
	if diff -u ${file} ${TMPDIR}/${zone}.$$; then
	    echo "No differences found."
	fi
	rm -f ${TMPDIR}/${zone}.$$
    fi;
done
