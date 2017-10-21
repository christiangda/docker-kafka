#!/usr/bin/env bash
set -e

KAFKA_SERVER_CONFIG_FILE=${KAFKA_HOME}/config/server.properties
KAFKA_ENV_CONFIG_PREFIX="KAFKA__"

# Functions

# MY_CONF_KEY=MY_VALUE --> my.conf.key=MY_VALUE
function convert_to_dotchar() {
  line=$1
  key=${line%=*}
  value=${line#*=}
  new_key=$(echo ${key} | tr '[:upper:]' '[:lower:]' | sed 's/_/./g')
  new_line=${new_key}\=${value}
  echo ${new_line}
}

function keys_to_dotchar() {
  for line in $(printenv | grep ${KAFKA_ENV_CONFIG_PREFIX} | sed "s/${KAFKA_ENV_CONFIG_PREFIX}//" | sort ); do
    new_line+=$(convert_to_dotchar ${line})
    echo ${new_line}
  done
}

function write_to_file() {
  echo "#### FILE MANAGED BY kafka-docker-cmd.sh ####" > ${KAFKA_SERVER_CONFIG_FILE}
  $1 >> ${KAFKA_SERVER_CONFIG_FILE}
}

#keys_to_dotchar $KAFKA_ENV_KEYS

write_to_file keys_to_dotchar
