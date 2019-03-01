#!/bin/bash

# sets up the environment to allow compilation of apache cassandra on a CSE machine

# need the maven ant tools to allow maven to be run from Cassandra's ant build files
mvn org.apache.maven.plugins:maven-dependency-plugin:2.1:get -Dartifact=org.apache.maven:maven-ant-tasks:2.1.3 -DrepoUrl=https://repo.maven.apache.org/maven2

# the build.xml reads this environment variable
export JAVA8_HOME=/usr/lib/jvm/java-1.8.0-openjdk
export JAVA_HOME=$JAVA8_HOME

if [ "x$CHECKERFRAMEWORK" == "x" ]; then
    CURDIR=`pwd`
    cd ~/
    git clone https://github.com/typetools/checker-framework
    cd checker-framework
    gradle assemble
    export CHECKERFRAMEWORK=`pwd`
    cd $CURDIR
fi

if [ "x$COMPLIANCECHECKER" == "x" ]; then
    CURDIR=`pwd`
    cd ~/
    git clone https://github.com/awslabs/aws-kms-compliance-checker
    cd aws-kms-compliance-checker
    gradle assemble
    export COMPLIANCECHECKER=`pwd`
    cd $CURDIR
fi

if [ "x$CRYPTOCHECKER" == "x" ]; then
    CURDIR=`pwd`
    cd ~/
    git clone https://github.com/awslabs/aws-crypto-policy-compliance-checker
    cd aws-crypto-policy-compliance-checker
    gradle assemble
    export CRYPTOCHECKER=`pwd`
    echo "crypto checker is here: $CRYPTOCHECKER"
    cd $CURDIR
fi


if [ $(basename $PWD) != 'cassandra' ]; then
    git clone https://github.com/kelloggm/cassandra.git
    cd cassandra/
fi

git checkout compliance-typecheckers

ant
