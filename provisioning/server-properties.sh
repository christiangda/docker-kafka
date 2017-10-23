#!/usr/bin/env bash
set -e

################################################################################
# global vars
KAFKA_SERVER_ENV_CONFIG_PREFIX="SERVER__"
KAFKA_SERVER_CONFIG_FILE=${KAFKA_HOME}/config/server.properties

################################################################################
# default values for files
# if a var does not exist, define it and set de default value
export SERVER__BROKER_ID=${SERVER__BROKER_ID:-0}
export SERVER__NUM_NETWORK_THREADS=${SERVER__NUM_NETWORK_THREADS:-3}
export SERVER__NUM_IO_THREADS=${SERVER__NUM_IO_THREADS:-8}
export SERVER__SOCKET_SEND_BUFFER_BYTES=${SERVER__SOCKET_SEND_BUFFER_BYTES:-102400}
export SERVER__SOCKET_RECEIVE_BUFFER_BYTES=${SERVER__SOCKET_RECEIVE_BUFFER_BYTES:-102400}
export SERVER__SOCKET_REQUEST_MAX_BYTES=${SERVER__SOCKET_REQUEST_MAX_BYTES:-104857600}
export SERVER__NUM_PARTITIONS=${SERVER__NUM_PARTITIONS:-1}
export SERVER__NUM_RECOVERY_THREADS_PER_DATA_DIR=${SERVER__NUM_RECOVERY_THREADS_PER_DATA_DIR:-1}
export SERVER__OFFSETS_TOPIC_REPLICATION_FACTOR=${SERVER__OFFSETS_TOPIC_REPLICATION_FACTOR:-1}
export SERVER__TRANSACTION_STATE_LOG_REPLICATION_FACTOR=${SERVER__TRANSACTION_STATE_LOG_REPLICATION_FACTOR:-1}
export SERVER__TRANSACTION_STATE_LOG_MIN_ISR=${SERVER__TRANSACTION_STATE_LOG_MIN_ISR:-1}
export SERVER__LOG_RETENTION_HOURS=${SERVER__LOG_RETENTION_HOURS:-168}
export SERVER__LOG_SEGMENT_BYTES=${SERVER__LOG_SEGMENT_BYTES:-1073741824}
export SERVER__LOG_RETENTION_CHECK_INTERVAL_MS=${SERVER__LOG_RETENTION_CHECK_INTERVAL_MS:-300000}
export SERVER__ZOOKEEPER_CONNECT=${SERVER__ZOOKEEPER_CONNECT:-"localhost:2181"}
export SERVER__ZOOKEEPER_CONNECTON_TIMEOUT_MS=${SERVER__ZOOKEEPER_CONNECTON_TIMEOUT_MS:-6000}
export SERVER__GROUP_INITIAL_REBALANCE_DELAY_MS=${SERVER__GROUP_INITIAL_REBALANCE_DELAY_MS=0}

################################################################################
# fixed parameters, don't take it from --env arguments
export SERVER__LOG_DIR=${KAFKA_LOG_DIR:-"/opt/kafka/logs"}
export SERVER__LOG_DIRS=${KAFKA_LOG_DIRS:-"/opt/kafka/logs"}
export SERVER__SASL_KERBEROS_KINIT_CMD="/usr/bin/kinit"

################################################################################
# importing utilities
source ${KAFKA_HOME}/provisioning/global-functions.sh

################################################################################
#

# get environments var for server
eval "declare -a SERVER_ENV_VARS=$(get_env_vars_from_prefix ${KAFKA_SERVER_ENV_CONFIG_PREFIX})"
#echo ${SERVER_ENV_VARS[0]}

# convert array content to prop array content
eval "declare -a SERVER_prop_VARS=$(env_array_to_prop_array ${SERVER_ENV_VARS[@]})"
# echo ${SERVER_prop_VARS[0]}

#
if [ -f $KAFKA_SERVER_CONFIG_FILE ]; then
  mv $KAFKA_SERVER_CONFIG_FILE $KAFKA_SERVER_CONFIG_FILE.backup
  echo "#### FILE MANAGED BY server-properties.sh SCRIPT ####" >> $KAFKA_SERVER_CONFIG_FILE
fi

# write all environments variables to config file
for line in "${SERVER_prop_VARS[@]}"; do
  write_to_file $line $KAFKA_SERVER_CONFIG_FILE
done
