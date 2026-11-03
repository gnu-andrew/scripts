#!/bin/bash
 
#
# Prepare an OpenJDK 17 release
#

. $HOME/projects/scripts/functions

RELEASE=$1
JDK_DIR=$2
GITOPTS=""
BOOT_JDK=${SYSTEM_JDK16}

if test "x${RELEASE}" = "xhelp"; then
    echo "${0} <RELEASE> <JDK_DIR>";
    exit -1;
fi

if test "x${JDK_DIR}" = "x"; then
    JDK_DIR=${PWD}
fi

if test -d ${JDK_DIR}; then
    echo "Using ${JDK_DIR} as OpenJDK 17 tree";
else
    echo "ERROR: ${JDK_DIR} is not a directory.";
    exit -1;
fi

if test "x${RELEASE}" = x; then
    RELEASE=master
else
    if test -f ${RELEASE}; then
	RELEASE=$(cat ${RELEASE})
    fi
fi

for release in ${RELEASE}; do
    echo "Creating release tarball for ${release}"
    echo git clone ${GITOPTS} -b ${release} ${JDK_DIR} ${release}
    git clone ${GITOPTS} -b ${release} ${JDK_DIR} ${release}

    # Generate .src-rev so build has knowledge of the revision the tarball was created from
    mkdir build
    pushd build
    sh ${PWD}/../${release}/configure --with-boot-jdk=${BOOT_JDK}
    make store-source-revision
    popd
    rm -rf build

    # Remove commit checks
    echo find ${release} -name '.jcheck' -print0 
    find ${release} -name '.jcheck' -print0 | xargs -0 rm -r
 
    # Remove history
    echo find ${release} -name '.hgtags' -print0
    find ${release} -name '.hgtags' -print0 | xargs -0 rm -v
    echo find ${release} -name '.hgignore' -print0 
    find ${release} -name '.hgignore' -print0 | xargs -0 rm -v
    echo find ${release} -name '.gitattributes' -print0
    find ${release} -name '.gitattributes' -print0 | xargs -0 rm -v
    echo find ${release} -name '.gitignore' -print0
    find ${release} -name '.gitignore' -print0 | xargs -0 rm -v
    echo find ${release} -name '.git' -print0
    find ${release} -name '.git' -print0 | xargs -0 rm -rv
    echo find ${release} -name '.github' -print0
    find ${release} -name '.github' -print0 | xargs -0 rm -rv

    echo tar cJf open${release}.tar.xz ${release}
    tar cJf open${release}.tar.xz ${release}
    echo rm -rf ${release}
    rm -rf ${release}
done

