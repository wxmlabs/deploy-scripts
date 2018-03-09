#!/bin/sh

###############################################################
# deploy.sh
# 
# Author: Wang Xuanmin
# Create: 2018-02-27
# Update: 2018-02-27
# 
# WEBAPP_NAME         deploy to tomcat/webapps/$WEBAPP_NAME
# PACKAGE_DIR         package war to the specified dir, and
#                     update configurations from the dir.
# CATLINA_HOME        tomcat working home.
###############################################################

WEBAPP_NAME=ehetong
PROJECT_NAME=ehetong-server
PROJECT_VERSION=0.1
PACKAGE_DIR=$PACKAGE_DIR
CATLINA_HOME=$CATLINA_HOME

if [ -z "$PACKAGE_DIR" ]; then
  PACKAGE_DIR=`pwd`
fi

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
EXECUTABLE=deploy-core.sh

if [ ! -x "$PRGDIR"/"$EXECUTABLE" ]; then
  echo "Cannot find $PRGDIR/$EXECUTABLE"
  echo "The file is absent or does not have execute permission"
  echo "This file is needed to run this program"
  exit 1
fi

export WEBAPP_NAME PROJECT_NAME PROJECT_VERSION PACKAGE_DIR CATLINA_HOME
#export VISIBLE=true
#export TEST=true

exec "$PRGDIR"/"$EXECUTABLE" "$@"
