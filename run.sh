#!/bin/bash

set -ex

JAVA_BIN=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/bin/java
JENKINS_HOME=

${JAVA_BIN} -jar /home/jenkins/swarm-client-${SWARM_CLIENT_VERSION}.jar -master ${MASTER_URL} -username ${MASTER_USER} -passwordEnvVariable MASTER_PASSVAR -labels Mono -executors ${SLAVE_EXES:-2} -fsroot /
