#!/usr/bin/env bash
set -e

################################################################################
# global vars
KAFKA_SERVER_ENV_CONFIG_PREFIX="KAFKA__"
KAFKA_SERVER_CONFIG_FILE=${KAFKA_HOME}/config/server.properties

################################################################################
# default values for files
# if a var does not exist, define it and set de default value
export KAFKA__BROKER_ID=${KAFKA__BROKER_ID:-0}
export KAFKA__NUM_NETWORK_THREADS=${KAFKA__NUM_NETWORK_THREADS:-3}
export KAFKA__NUM_IO_THREADS=${KAFKA__NUM_IO_THREADS:-8}
export KAFKA__SOCKET_SEND_BUFFER_BYTES=${KAFKA__SOCKET_SEND_BUFFER_BYTES:-102400}
export KAFKA__SOCKET_RECEIVE_BUFFER_BYTES=${KAFKA__SOCKET_RECEIVE_BUFFER_BYTES:-102400}
export KAFKA__SOCKET_REQUEST_MAX_BYTES=${KAFKA__SOCKET_REQUEST_MAX_BYTES:-104857600}
export KAFKA__NUM_PARTITIONS=${KAFKA__NUM_PARTITIONS:-1}
export KAFKA__NUM_RECOVERY_THREADS_PER_DATA_DIR=${KAFKA__NUM_RECOVERY_THREADS_PER_DATA_DIR:-1}
export KAFKA__OFFSETS_TOPIC_REPLICATION_FACTOR=${KAFKA__OFFSETS_TOPIC_REPLICATION_FACTOR:-1}
export KAFKA__TRANSACTION_STATE_LOG_REPLICATION_FACTOR=${KAFKA__TRANSACTION_STATE_LOG_REPLICATION_FACTOR:-1}
export KAFKA__TRANSACTION_STATE_LOG_MIN_ISR=${KAFKA__TRANSACTION_STATE_LOG_MIN_ISR:-1}
export KAFKA__LOG_RETENTION_HOURS=${KAFKA__LOG_RETENTION_HOURS:-168}
export KAFKA__LOG_SEGMENT_BYTES=${KAFKA__LOG_SEGMENT_BYTES:-1073741824}
export KAFKA__LOG_RETENTION_CHECK_INTERVAL_MS=${KAFKA__LOG_RETENTION_CHECK_INTERVAL_MS:-300000}
export KAFKA__ZOOKEEPER_CONNECT=${KAFKA__ZOOKEEPER_CONNECT:-"localhost:2181"}
export KAFKA__ZOOKEEPER_CONNECTON_TIMEOUT_MS=${KAFKA__ZOOKEEPER_CONNECTON_TIMEOUT_MS:-6000}
export KAFKA__GROUP_INITIAL_REBALANCE_DELAY_MS=${KAFKA__GROUP_INITIAL_REBALANCE_DELAY_MS=0}

################################################################################
# fixed parameters, don't take it from --env arguments
export KAFKA__LOG_DIRS=${KAFKA_LOG_DIRS:-"/opt/kafka/logs"}

################################################################################
# importing utilities
source ${KAFKA_HOME}/provisioning/global-functions.sh

################################################################################
#

# get environments var for server
eval "declare -a SERVER_ENV_VARS=$(get_env_vars_from_prefix ${KAFKA_SERVER_ENV_CONFIG_PREFIX})"
#echo ${SERVER_ENV_VARS[0]}

# convert array content to yaml array content
eval "declare -a SERVER_YAML_VARS=$(env_array_to_yaml_array ${SERVER_ENV_VARS[@]})"
# echo ${SERVER_YAML_VARS[0]}

#
if [ -f $KAFKA_SERVER_CONFIG_FILE ]; then
  mv $KAFKA_SERVER_CONFIG_FILE $KAFKA_SERVER_CONFIG_FILE.backup
  echo "---" > $KAFKA_SERVER_CONFIG_FILE
  echo "#### FILE MANAGED BY server-properties.sh SCRIPT ####" >> $KAFKA_SERVER_CONFIG_FILE
fi

# write all environments variables to config file
for line in "${SERVER_YAML_VARS[@]}"; do
  write_to_file $line $KAFKA_SERVER_CONFIG_FILE
done
