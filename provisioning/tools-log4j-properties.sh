#!/usr/bin/env bash
set -e

################################################################################
# global vars
KAFKA_LOG4J_ENV_CONFIG_PREFIX="LOG4J__"
KAFKA_LOG4J_CONFIG_FILE=${KAFKA_HOME}/config/tools-log4j.properties

################################################################################
# default values for server file
# if a var does not exist, define it and set de default value
export LOG4J__LOG4J_APPENDER_STDERR=${LOG4J__LOG4J_APPENDER_STDERR:"org.apache.log4j.ConsoleAppender"}
export LOG4J__LOG4J_APPENDER_STDERR_LAYOUT=${LOG4J__LOG4J_APPENDER_STDERR_LAYOUT:"org.apache.log4j.PatternLayout"}

export LOG4J__NUM_IO_THREADS=${LOG4J__NUM_IO_THREADS:-8}
export LOG4J__SOCKET_SEND_BUFFER_BYTES=${LOG4J__SOCKET_SEND_BUFFER_BYTES:-102400}
export LOG4J__SOCKET_RECEIVE_BUFFER_BYTES=${LOG4J__SOCKET_RECEIVE_BUFFER_BYTES:-102400}
export LOG4J__SOCKET_REQUEST_MAX_BYTES=${LOG4J__SOCKET_REQUEST_MAX_BYTES:-104857600}
export LOG4J__NUM_PARTITIONS=${LOG4J__NUM_PARTITIONS:-1}
export LOG4J__NUM_RECOVERY_THREADS_PER_DATA_DIR=${LOG4J__NUM_RECOVERY_THREADS_PER_DATA_DIR:-1}
export LOG4J__OFFSETS_TOPIC_REPLICATION_FACTOR=${LOG4J__OFFSETS_TOPIC_REPLICATION_FACTOR:-1}
export LOG4J__TRANSACTION_STATE_LOG_REPLICATION_FACTOR=${LOG4J__TRANSACTION_STATE_LOG_REPLICATION_FACTOR:-1}
export LOG4J__TRANSACTION_STATE_LOG_MIN_ISR=${LOG4J__TRANSACTION_STATE_LOG_MIN_ISR:-1}
export LOG4J__LOG_RETENTION_HOURS=${LOG4J__LOG_RETENTION_HOURS:-168}
export LOG4J__LOG_SEGMENT_BYTES=${LOG4J__LOG_SEGMENT_BYTES:-1073741824}
export LOG4J__LOG_RETENTION_CHECK_INTERVAL_MS=${LOG4J__LOG_RETENTION_CHECK_INTERVAL_MS:-300000}
export LOG4J__ZOOKEEPER_CONNECT=${LOG4J__ZOOKEEPER_CONNECT:-"localhost:2181"}
export LOG4J__ZOOKEEPER_CONNECTON_TIMEOUT_MS=${LOG4J__ZOOKEEPER_CONNECTON_TIMEOUT_MS:-6000}
export LOG4J__GROUP_INITIAL_REBALANCE_DELAY_MS=${LOG4J__GROUP_INITIAL_REBALANCE_DELAY_MS=0}

################################################################################
# fixed parameters, don't take it from --env arguments
export LOG4J__LOG_DIR=${KAFKA_LOG_DIR:-"/opt/kafka/logs"}
export LOG4J__LOG_DIRS=${KAFKA_LOG_DIRS:-"/opt/kafka/logs"}
export LOG4J__SASL_KERBEROS_KINIT_CMD="/usr/bin/kinit"

################################################################################
# importing utilities
source ${KAFKA_HOME}/provisioning/global-functions.sh

################################################################################
#

# get environments var for server
eval "declare -a SERVER_ENV_VARS=$(get_env_vars_from_prefix ${KAFKA_LOG4J_ENV_CONFIG_PREFIX})"
#echo ${SERVER_ENV_VARS[0]}

# convert array content to prop array content
eval "declare -a SERVER_prop_VARS=$(env_array_to_prop_array ${SERVER_ENV_VARS[@]})"
# echo ${SERVER_prop_VARS[0]}

#
if [ -f $KAFKA_LOG4J_CONFIG_FILE ]; then
  mv $KAFKA_LOG4J_CONFIG_FILE $KAFKA_LOG4J_CONFIG_FILE.backup
  echo "#### FILE MANAGED BY server-properties.sh SCRIPT ####" >> $KAFKA_LOG4J_CONFIG_FILE
fi

# write all environments variables to config file
for line in "${SERVER_prop_VARS[@]}"; do
  write_to_file $line $KAFKA_LOG4J_CONFIG_FILE
done
