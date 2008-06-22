#!/bin/bash

if [ ! -e environment ]; then
    echo "Please install an environment";
    exit -1;
fi

for scripts in icedtea.sh icedtea-release.sh icedtea-full.sh; do
    ln -s $scripts $(echo $scripts|sed 's/tea/tea6/')
done
