#!/bin/sh

. $HOME/projects/scripts/functions

VERSION=$1
REPO_LOCATION=$2
DEFAULT_LOCATION=${HOME}/projects/openjdk/upstream/jdk11u-dev
SCRIPT=${HOME}/projects/rhel/java-11-openjdk/generate_source_tarball.sh
USAGE_INFO="${0} <VERSION> <REPO_LOCATION>"
OPENJDK_VERSION=jdk11u
BOOT_JDK=${SYSTEM_JDK11}

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

echo "Creating tarball for ${VERSION} from ${REPO_LOCATION}...";
cd ${TMPDIR}

VERSION=${VERSION} \
FILE_NAME_ROOT=openjdk-${OPENJDK_VERSION}-${VERSION} \
REPO_ROOT=${REPO_LOCATION} \
BOOT_JDK=${BOOT_JDK} \
${SCRIPT}
