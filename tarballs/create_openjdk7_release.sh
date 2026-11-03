#!/bin/bash
 
#
# Prepare an OpenJDK 7 release
#

JDK_DIR=$1
RELEASE=$2
HGOPTS="--stream"
SCRIPT_DIR=$(dirname ${0})

if test "x${JDK_DIR}" = "xhelp"; then
    echo "${0} <JDK_DIR> <RELEASE>";
    exit -1;
fi

if test "x${JDK_DIR}" = "x"; then
    JDK_DIR=${PWD}
fi

if test -d ${JDK_DIR}; then
    echo "Using ${JDK_DIR} as OpenJDK 7 tree";
else
    echo "ERROR: ${JDK_DIR} is not a directory.";
    exit -1;
fi

if test "x${RELEASE}" = x; then
    RELEASE=tip
else
    if test -f ${RELEASE}; then
	RELEASE=$(cat ${RELEASE})
    fi
fi

for release in ${RELEASE}; do
    echo "Creating release tarball for ${release}"
    echo hg clone ${HGOPTS} -r ${release} ${JDK_DIR} ${release}
    hg clone ${HGOPTS} -r ${release} ${JDK_DIR} ${release}
    for repo in $(${SCRIPT_DIR}/discover_trees.sh ${JDK_DIR}); do
	echo hg clone ${HGOPTS} -r ${release} ${JDK_DIR}/${repo} ${release}/${repo}
	hg clone ${HGOPTS} -r ${release} ${JDK_DIR}/${repo} ${release}/${repo}
    done
    # Remove commit checks
    echo find ${release} -name '.jcheck' -print0 
    find ${release} -name '.jcheck' -print0 | xargs -0 rm -r
 
    # Remove history
    echo find ${release} -name '.hgtags' -print0
    find ${release} -name '.hgtags' -print0 | xargs -0 rm -v
    echo find ${release} -name '.hgignore' -print0 
    find ${release} -name '.hgignore' -print0 | xargs -0 rm -v
    echo find ${release} -name '.hg' -print0 
    find ${release} -name '.hg' -print0 | xargs -0 rm -rv

    echo tar cJf open${release}.tar.xz ${release}
    tar cJf open${release}.tar.xz ${release}
    echo rm -rf ${release}
    rm -rf ${release}
done

