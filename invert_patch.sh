#!/bin/sh

PATCH=${1}

if test "${PATCH}" = ""; then
    echo "${0} <PATCH>";
    exit 1;
fi

cat ${PATCH} |sed 's#^-#?#'|sed 's#^+#-#'|sed 's#^?#+#'
