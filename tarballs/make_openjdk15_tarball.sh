#!/bin/sh

VERSION=$1
CURVES=$2
REPO_LOCATION=$3
DEFAULT_CURVES=4
DEFAULT_LOCATION=${HOME}/projects/openjdk/upstream/jdk15u
SCRIPT=~/projects/fedora/java-latest-openjdk/generate_source_tarball.sh
USAGE_INFO="${0} <VERSION> <CURVES> <REPO_LOCATION>"
ICEDTEA_LOCATION=${HOME}/projects/openjdk/icedtea15

if test "x${VERSION}" = "x"; then
    echo "No version specified.";
    echo ${USAGE_INFO};
    exit 1;
fi

if test "x${CURVES}" = "x"; then
    CURVES=${DEFAULT_CURVES};
fi

if test "x${REPO_LOCATION}" = "x"; then
    REPO_LOCATION=${DEFAULT_LOCATION};
fi

if test ${CURVES} -eq 4 ; then
    export PR3803=${ICEDTEA_LOCATION}/patches/pr3803.patch
    echo "FSG patch: ${PR3803}"
    if ! grep 'PR3803' ${SCRIPT} > /dev/null; then
	echo "Current checked-out tarball generation script doesn't support PR3803";
	exit 3;
    fi
else
    echo "Invalid number of curves: ${CURVES}";
    exit 2;
fi

echo "Creating tarball for ${VERSION} with support for ${CURVES} curves...";

cd /tmp

VERSION=${VERSION} \
FILE_NAME_ROOT=jdk-updates-jdk15u-${VERSION} \
REPO_ROOT=${REPO_LOCATION} \
${SCRIPT}
