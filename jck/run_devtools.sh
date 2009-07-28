JCKDIR=$HOME/builder/jck/6b
JDK=$JCKDIR/jdk

if [ ! -e $JCKDIR/JCK-devtools-6b/work ];
then
    CREATE_WORK="-create";
fi

cd $JCKDIR/JCK-devtools-6b
$JDK/bin/java -jar lib/javatest.jar -config ../devtools-config.jti -workDir $CREATE_WORK $JCKDIR/JCK-devtools-6b/work -testSuite $JCKDIR/JCK-devtools-6b -verbose:progress -excludeList $JCKDIR/jdk6b.jtx &

