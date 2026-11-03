#!/bin/sh

VERSION=$1
REPO_LOCATION=$2
DEFAULT_LOCATION=${HOME}/projects/openjdk/upstream/jdk
SCRIPT=~/projects/fedora/java-latest-openjdk/generate_source_tarball.sh
USAGE_INFO="${0} <VERSION> <REPO_LOCATION>"
OPENJDK_VERSION=jdk19u
ICEDTEA_LOCATION=${HOME}/projects/openjdk/icedtea
ICEDTEA_VERSION=14.0

if test "x${VERSION}" = "x"; then
    echo "No version specified.";
    echo ${USAGE_INFO};
    exit 1;
fi

if test "x${REPO_LOCATION}" = "x"; then
    REPO_LOCATION=${DEFAULT_LOCATION};
fi

if test "x${TMPDIR}" = "x"; then
    TMPDIR=/tmp;
fi

echo "Temporary directory: ${TMPDIR}"

echo "Generating ECC patch using IcedTea revision ${ICEDTEA_VERSION} from ${ICEDTEA_LOCATION}..."
PATCH_FILE=pr3823.patch
if ! git -C ${ICEDTEA_LOCATION} show origin/${ICEDTEA_VERSION}:patches/${PATCH_FILE} > ${TMPDIR}/${PATCH_FILE} ; then
    echo "Could not retrieve patch from git";
    exit 2;
fi
if test -s ${TMPDIR}/${PATCH_FILE} ; then
    export PR3823=${TMPDIR}/${PATCH_FILE}
    echo "FSG patch: ${PR3823}"
else
    echo "Patch is of zero size";
    exit 3;
fi

if ! grep 'PR3823' ${SCRIPT} > /dev/null; then
    echo "Current checked-out tarball generation script doesn't support PR3823";
    exit 4;
fi

echo "Creating tarball for ${VERSION} from ${REPO_LOCATION}...";
cd ${TMPDIR}

VERSION=${VERSION} \
FILE_NAME_ROOT=openjdk-${OPENJDK_VERSION}-${VERSION} \
REPO_ROOT=${REPO_LOCATION} \
${SCRIPT}
