#!/usr/bin/env bash
set -e

# global vars
KAFKA_SERVER_ENV_CONFIG_PREFIX="KAFKA__"
KAFKA_SERVER_CONFIG_FILE=${KAFKA_HOME}/config/server.properties

# importing utilities
source global-functions.sh
