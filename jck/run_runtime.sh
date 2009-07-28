JCKDIR=$HOME/builder/jck/6b
JDK=$JCKDIR/jdk

cd $JCKDIR
./build_native.sh $JCKDIR/JCK-runtime-6b

if [ ! -e $JCKDIR/JCK-runtime-6b/work ];
then
    CREATE_WORK="-create";
fi

$JDK/bin/java -jar JCK-runtime-6b/lib/javatest.jar -config runtime-config.jti -workDir $CREATE_WORK $JCKDIR/JCK-runtime-6b/work -testSuite $JCKDIR/JCK-runtime-6b -verbose:progress -excludeList $JCKDIR/jdk6b.jtx &

