#!/bin/sh

VERSION=$1
CURVES=$2
REPO_LOCATION=$3
DEFAULT_CURVES=3
DEFAULT_LOCATION=/mirrored/security/latest-shenandoah.11
SCRIPT=~/projects/rhel/java-11-openjdk/generate_source_tarball.sh
USAGE_INFO="${0} <VERSION> <CURVES> <REPO_LOCATION>"
ICEDTEA_LOCATION=${HOME}/projects/openjdk/icedtea11

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

if test ${CURVES} -eq 3; then
    export PR3681=${ICEDTEA_LOCATION}/patches/pr3681.patch
    echo "FSG patch: ${PR3681}"
    if ! grep 'PR3681' ${SCRIPT} > /dev/null; then
	echo "Current checked-out tarball generation script doesn't support PR3681";
	exit 3;
    fi
elif test ${CURVES} -eq 4; then
    export PR3751=${ICEDTEA_LOCATION}/patches/pr3751.patch
    echo "FSG patch: ${PR3751}"
    if ! grep 'PR3751' ${SCRIPT} > /dev/null; then
	echo "Current checked-out tarball generation script doesn't support PR3751";
	exit 4;
    fi
else
    echo "Invalid number of curves: ${CURVES}";
    exit 2;
fi

echo "Creating tarball for ${VERSION} with support for ${CURVES} curves...";

cd /tmp

VERSION=${VERSION} \
FILE_NAME_ROOT=shenandoah-jdk11-${VERSION} \
REPO_ROOT=${REPO_LOCATION} \
${SCRIPT}
