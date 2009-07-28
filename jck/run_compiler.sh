JCKDIR=$HOME/builder/jck/6b
JDK=$JCKDIR/jdk

if [ ! -e $JCKDIR/JCK-compiler-6b/work ];
then
    CREATE_WORK="-create";
fi

$JDK/bin/java -jar JCK-compiler-6b/lib/javatest.jar -config compiler-config.jti -workDir $CREATE_WORK $JCKDIR/JCK-compiler-6b/work -testSuite $JCKDIR/JCK-compiler-6b -verbose:progress -excludeList $JCKDIR/jdk6b.jtx &

