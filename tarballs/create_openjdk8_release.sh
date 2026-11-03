#!/bin/bash

#
# Prepare an OpenJDK 8 release
#

set -e

. $HOME/projects/scripts/functions

RELEASE=$1
JDK_DIR=$2
GITOPTS=""
BOOT_JDK=${SYSTEM_JDK8}

if test "x${RELEASE}" = "xhelp"; then
    echo "${0} <RELEASE> <JDK_DIR>";
    exit 1;
fi

if test "x${JDK_DIR}" = "x"; then
    JDK_DIR=${PWD}
fi

if test -d ${JDK_DIR}; then
    echo "Using ${JDK_DIR} as OpenJDK 8 tree";
else
    echo "ERROR: ${JDK_DIR} is not a directory.";
    exit 2;
fi

if test "x${RELEASE}" = x; then
    RELEASE=master
else
    if test -f ${RELEASE}; then
        RELEASE=$(cat ${RELEASE})
    fi
fi

WORKDIR=$(mktemp --directory --tmpdir "temp-${RELEASE}-release-tarball-XXX")

pushd "${WORKDIR}"
for release in ${RELEASE}; do
    TARBALL_NAME="open${release}.tar.xz"

    echo "Creating release tarball for ${release}"
    echo git clone ${GITOPTS} -b ${release} ${JDK_DIR} ${release}
    git clone ${GITOPTS} -b ${release} ${JDK_DIR} ${release}

    # Capture timestamp
    TAR_TIME="$(git -C ${release} log --max-count 1 --format=%cI)"

    # Generate .src-rev so build has knowledge of the revision the tarball was created from
    mkdir build
    pushd build
    sh ${PWD}/../${release}/configure --with-boot-jdk=${BOOT_JDK}
    make store-source-revision
    popd
    rm -rf build

    # Remove commit checks
    echo "find ${release} -depth -type d -and -name '.jcheck' -execdir rm -rv '{}' '+'"
    find ${release} -depth -type d -and -name '.jcheck' -execdir rm -rv '{}' '+'

    # Remove history
    echo "find ${release} -name '.hgtags' -execdir rm -v {} +"
    find ${release} -name '.hgtags' -execdir rm -v '{}' '+'
    echo "find ${release} -name '.hgignore' -execdir rm -v '{}' '+'"
    find ${release} -name '.hgignore' -execdir rm -v '{}' '+'
    echo "find ${release} -name '.gitattributes' -execdir rm -v '{}' '+'"
    find ${release} -name '.gitattributes' -execdir rm -v '{}' '+'
    echo "find ${release} -name '.gitignore' -execdir rm -v '{}' '+'"
    find ${release} -name '.gitignore' -execdir rm -v '{}' '+'
    echo "find ${release} -depth -type d -and -name '.git' -execdir rm -rv '{}' '+'"
    find ${release} -depth -type d -and -name '.git' -execdir rm -rv '{}' '+'
    echo "find ${release} -depth -type d -and -name '.github' -execdir rm -rv '{}' '+'"
    find ${release} -depth -type d -and -name '.github' -execdir rm -rv '{}' '+'

    TAR_OPTS="--mtime=${TAR_TIME} --owner=root --group=root --sort=name"
    echo tar ${TAR_OPTS} -cJf ${TARBALL_NAME} ${release}
    XZ_OPT=${XZ_OPT-"-T0"} tar ${TAR_OPTS} -cJf ${TARBALL_NAME} ${release}
    echo rm -rf ${release}
    rm -rf ${release}

    echo "Tarball generated in ${WORKDIR}/${TARBALL_NAME}"
    stat ${WORKDIR}/${TARBALL_NAME}
done
popd
