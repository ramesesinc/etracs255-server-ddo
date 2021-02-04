#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

JAVA_OPTS="-Dosiris.run.dir=$RUN_DIR -Dosiris.base.dir=$BASE_DIR"

JAVA="java"

$JAVA $JAVA_OPTS -classpath lib/*:. com.rameses.server.Shutdown

