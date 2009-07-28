JCKDIR=$1

cd $JCKDIR/..
rm -rf lib resources
mkdir lib resources
echo "Copying resources"
cp -r $JCKDIR/tests/api/javax_management/loading/data/* resources
echo "Building jckatr"
gcc -fPIC -shared -o lib/libjckatr.so -I$JCKDIR \
    $JCKDIR/src/share/lib/atr/jckatr.c
echo "Building jckjni"
gcc -fPIC -shared -o lib/libjckjni.so -I$JCKDIR \
    -I$JCKDIR/src/share/lib/jni/include \
    -I$JCKDIR/src/share/lib/jni/include/solaris \
    $JCKDIR/src/share/lib/jni/jckjni.c
echo "Building jckjvmti"
gcc -fPIC -shared -o lib/libjckjvmti.so -I$JCKDIR \
    -I$JCKDIR/src/share/lib/jvmti/include \
    -I$JCKDIR/src/share/lib/jni/include \
    -I$JCKDIR/src/share/lib/jni/include/solaris \
    $JCKDIR/src/share/lib/jvmti/jckjvmti.c
echo "Building systemInfo"
gcc -fPIC -shared -o lib/libsystemInfo.so \
    -I$JCKDIR/src/share/lib/jni/include \
    -I$JCKDIR/src/share/lib/jni/include/solaris \
    $JCKDIR/tests/api/javax_management/loading/data/archives/src/C/com_sun_management_mbeans_loading_SystemInfoUseNativeLib.c
echo "Building id"
gcc -fPIC -shared -o lib/libjmxlibid.so \
    -I$JCKDIR/src/share/lib/jni/include \
    -I$JCKDIR/src/share/lib/jni/include/solaris \
    $JCKDIR/tests/api/javax_management/loading/data/archives/src/C/com_sun_management_mbeans_loading_GetLibIdFromNativeLib.c   
echo "Building genrandom"
gcc -fPIC -shared -o lib/libgenrandom.so \
    -I$JCKDIR/src/share/lib/jni/include \
    -I$JCKDIR/src/share/lib/jni/include/solaris \
    $JCKDIR/tests/api/javax_management/loading/data/archives/src/C/com_sun_management_mbeans_loading_RandomGen.c
echo "Updating jar"
cd lib
jar uf ../resources/archives/MBeanUseNativeLib.jar libsystemInfo.so
rm libsystemInfo.so
