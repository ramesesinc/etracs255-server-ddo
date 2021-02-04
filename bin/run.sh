#!/bin/sh
RUN_DIR=`pwd`
cd ..

BASE_DIR=`pwd`

JAVA_OPTS="-Dosiris.run.dir=$RUN_DIR -Dosiris.base.dir=$BASE_DIR"

JAVA="java"

echo "=============================================================="
echo ""
echo "   Osiris Server 3 (ETRACS) "
echo "" 
echo "   JAVA     :  $JAVA"
echo "   BASE_DIR :  $BASE_DIR"
echo " "
echo "==============================================================="

$JAVA $JAVA_OPTS -classpath lib/*:. com.rameses.main.bootloader.MainBootLoader

