#!/bin/sh

. $HOME/projects/scripts/functions

VERSION=$1
REPO_LOCATION=$2
DEFAULT_LOCATION=${PWD}
SCRIPT=${HOME}/projects/centos/java-1.8.0-openjdk/scripts/generate_source_tarball.sh
USAGE_INFO="${0} <VERSION> <REPO_LOCATION>"
BOOT_JDK=${SYSTEM_JDK8}

if test "x${VERSION}" = "x"; then
    echo "No version specified.";
    echo ${USAGE_INFO};
    exit 1;
fi

if test "x${REPO_LOCATION}" = "x"; then
    REPO_LOCATION=${DEFAULT_LOCATION};
fi

echo "Creating tarball for ${VERSION} from ${REPO_LOCATION}...";

VERSION=${VERSION} \
FILE_NAME_ROOT=${VERSION} \
REPO_ROOT=${REPO_LOCATION} \
BOOT_JDK=${BOOT_JDK} \
WITH_TEMP=1 \
${SCRIPT}
