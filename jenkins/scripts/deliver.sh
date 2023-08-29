#!/usr/bin/env bash

<<com
echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following complex command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=`mvn help:evaluate -Dexpression=project.name | grep "^[^\[]"`
set +x

echo 'The following complex command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=`mvn help:evaluate -Dexpression=project.version | grep "^[^\[]"`
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
#java -jar target/${NAME}-${VERSION}.jar
java -jar target/${VERSION}.jar
com
echo 'This script installs and runs a Maven-built Java application'

# Install the Maven artifact into the local Maven repository
mvn install

# Get the name and version of the project from the pom.xml
NAME=$(mvn help:evaluate -Dexpression=project.name -q -DforceStdout)
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "JAR file path: $(realpath target/${NAME}-${VERSION}.jar)"

# Run the Java application
java -jar target/${NAME}-${VERSION}.jar
