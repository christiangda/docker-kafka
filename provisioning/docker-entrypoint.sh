#!/usr/bin/env bash
set -e

source ${KAFKA_HOME}/provisioning/server-properties.sh

if [ "$1" = "WITH_INTERNAL_ZOOKEEPER" ]; then

  # start zookeeper daemon in background
  sed -i 's/dataDir\=\/tmp\/zookeeper/dataDir\=\/opt\/kafka\/data/g' ${KAFKA_HOME}/config/zookeeper.properties
  ${KAFKA_HOME}/bin/zookeeper-server-start.sh ${KAFKA_HOME}/config/zookeeper.properties 2>&1 1>${KAFKA_HOME}/logs/zookeeper.log &

  # remove the firts argument "WITH_INTERNAL_ZOOKEEPER"
  shift
fi

exec "$@"
