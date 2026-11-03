#!/bin/sh

DIR=${1}
COMMIT=${2}

if test "x${DIR}" = "x"; then
    echo "${0} <DIR> <COMMIT>";
    exit 1;
fi

if test "x${COMMIT}" = "x"; then
    echo "${0} <DIR> <COMMIT>";
    exit 2;
fi

echo "Import ${COMMIT} from ${DIR}...";
git -C ${DIR} format-patch -1 --stdout -k ${COMMIT}|git am -k
