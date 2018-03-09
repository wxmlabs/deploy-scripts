#!/bin/sh

###############################################################
# deploy-core.sh
# 
# Author: Wang Xuanmin
# Create: 2018-02-27
# Update: 2018-02-27
# 
# WEBAPP_NAME         deploy to tomcat/webapps/$WEBAPP_NAME
# PROJECT_NAME        project name. see rootProject.name in setting.gradle file.
# PROJECT_VERSION     project version. see version in build.gradle file.
# PACKAGE_DIR         package war to the specified dir, and
#                     update configurations from the dir.
# CATLINA_HOME        tomcat working home.
###############################################################

PROJECT_DIR=$(cd "$(dirname $0)";pwd)

if [ -n "$1" ]; then
  PACKAGE_DIR=$1
fi

# absolute path
PACKAGE_DIR=$(cd "$PACKAGE_DIR";pwd)
PACKAGE_FILE_NAME=$WEBAPP_NAME-$(date "+%Y%m%d").war

if [ -n "$VISIBLE" ]; then
  echo WEBAPP_NAME=$WEBAPP_NAME
  echo PROJECT_NAME=$PROJECT_NAME
  echo PROJECT_VERSION=$PROJECT_VERSION
  echo PACKAGE_DIR=$PACKAGE_DIR
  echo CATLINA_HOME=$CATLINA_HOME
fi

if [ -n "$TEST" ]; then
  exit 0
fi

if [ -z "$WEBAPP_NAME" ]; then
  echo "needs WEBAPP_NAME."
  exit 1
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "needs PROJECT_NAME."
  exit 1
fi

if [ -z "$PROJECT_VERSION" ]; then
  echo "needs PROJECT_VERSION."
  exit 1
fi

if [ -z "$PACKAGE_DIR" ]; then
  echo "needs PACKAGE_DIR."
  exit 1
fi

if [ -z "$CATLINA_HOME" ]; then
  echo "needs CATLINA_HOME."
  exit 1
fi

GRAILS_WRAPPER=$PROJECT_DIR/grailsw

if [ -z "$WAR_FILE" ]; then
  if [ -x "$GRAILS_WRAPPER" ]; then
    $GRAILS_WRAPPER assemble
  fi
  WAR_FILE=$PROJECT_DIR/build/libs/$PROJECT_NAME-$PROJECT_VERSION.war.original
fi

if [ ! -e "$WAR_FILE" ]; then
  echo "war file $WAR_FILE not exists."
  exit 1  
fi

# copy war to package dir
cp -f $WAR_FILE $PACKAGE_DIR/$PACKAGE_FILE_NAME

# update package configurations
if [ -d "$PACKAGE_DIR/WEB-INF" ]; then
  cd $PACKAGE_DIR
  jar uvf $PACKAGE_FILE_NAME WEB-INF/classes/config.properties WEB-INF/classes/config/application.yml
  cd $PROJECT_DIR
fi

# kill tomcat
ps -ef | grep "Dcatalina.home=$CATLINA_HOME" | grep -v tail | grep -v grep | awk {'print $2'} | xargs kill -9

# deploy war
cd $CATLINA_HOME/webapps
rm -rf $WEBAPP_NAME
mkdir $WEBAPP_NAME
cd $WEBAPP_NAME
cp $PACKAGE_DIR/$PACKAGE_FILE_NAME .
jar xf $PACKAGE_FILE_NAME
rm $PACKAGE_FILE_NAME
cd $PROJCET_DIR

# startup tomca$CATLINA_HOME/bin/startup.sh
$CATLINA_HOME/bin/startup.sh

