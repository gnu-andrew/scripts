#!/bin/bash

if test "x$TMPDIR" = "x"; then
    dir="/tmp";
else
    dir=$TMPDIR;
fi

if test -d .hg && test -x .hg ; then
    echo "Detected Mercurial";
    URL=$(cat .hg/hgrc |egrep '^default(\W)*=(\W)*'|sed 's#^default\W*=\W*##')
    hg log --template="Revision: ${URL}/rev/{node|short}\n{desc}\n\n" > ChangeLog
    hg diff > ${dir}/diff
elif test -d .git && test -x .git ; then
    echo "Detected git";
    URL=$(git remote show -n origin | grep 'Fetch' | cut -d ':' -f 2 |sed 's#git@#https://#')
    PROJECT=$(git remote show -n origin | grep 'Fetch' | cut -d ':' -f 3 | sed 's#.git##')
    git log --format="Revision: ${URL}/${PROJECT}/commit/%H%nAuthor: %an %ae%nDate: %ad%n%n%s%n%n%b" > ChangeLog
    git diff > ${dir}/diff
    git diff --cached > ${dir}/diff.cached
else
    echo "Couldn't detect repository system";
fi
gen_patch_file_list.sh < ${dir}/diff > ${dir}/ChangeLog
if [ -e ${dir}/diff.cached ] ; then
    gen_patch_file_list.sh < ${dir}/diff.cached > ${dir}/ChangeLog.cached
    cat ${dir}/ChangeLog ${dir}/ChangeLog.cached > ${dir}/ChangeLog.combined
fi
for logs in ChangeLog{,.cached,.combined}; do
    cat ChangeLog >> ${dir}/${logs}
done
