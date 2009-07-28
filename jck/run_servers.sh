#!/bin/bash

JDK=$HOME/builder/jck/6b/jdk

echo Starting rmid...
$JDK/bin/rmid -J-Dsun.rmi.activation.execPolicy=none &
echo Starting tnameserv...
$JDK/bin/tnameserv -ORBInitialPort 1234 
