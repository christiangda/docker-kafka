#!/usr/bin/env bash
set -e

source ${KAFKA_HOME}/provisioning/server-properties.sh

#if [ "$1" = 'bin/kafka-server-start.sh' ]; then
#  exec "$@"
#fi

exec "$@"
