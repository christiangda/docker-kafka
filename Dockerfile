ARG CONTAINER_JAVA_VERSION=9
FROM openjdk:${CONTAINER_JAVA_VERSION}-jre-slim

MAINTAINER Christian González Di Antonio <christiangda@gmail.com>

# Arguments from docker build proccess
ARG SCALA_VERSION
ARG KAFKA_DOWNLOAD_MIRROR
ARG KAFKA_VERSION

# Environment variables
ENV container=docker \
    SCALA_VERSION=${SCALA_VERSION:-2.11} \
    KAFKA_VERSION=${KAFKA_VERSION:-1.0.0} \
    KAFKA_DOWNLOAD_MIRROR=${KAFKA_DOWNLOAD_MIRROR:-"https://dist.apache.org/repos/dist/release/kafka"} \
    KAFKA_HOME="/opt/kafka" \
    KAFKA_LOG_DIRS="/opt/kafka/logs" \
    KAFKA_PORT=9092 \
    INTERNAL_ZOOKEEPER_PORT=2181 \
    INTERNAL_ZOOKEEPER_LOGS_PATH="/opt/kafka/zookeeper/logs" \
    INTERNAL_ZOOKEEPER_DATA_PATH="/opt/kafka/zookeeper/data"

# Container's Labels
LABEL Description "Apache Kafka docker image" \
      Vendor "Christian González" \
      Name "Apache Kafka" \
      Version ${SCALA_VERSION}-${KAFKA_VERSION}

LABEL Build "docker build --no-cache --rm \
            --build-arg SCALA_VERSION=2.11 \
            --build-arg KAFKA_VERSION=1.0.0 \
            --tag christiangda/kafka:2.11-1.0.0 \
            --tag christiangda/kafka:latest \
            --tag christiangda/kafka:canary ." \
      Run "docker run --tty --interactive --rm --name "kafka-01" christiangda/kafka" \
      Connect "docker exec --tty --interactive <container id from 'doclogsker ps' command> /bin/bash"

# Create service's user
RUN addgroup --gid 1000 kafka \
    && mkdir -p ${KAFKA_HOME}/bin \
    && adduser --uid 1000 --no-create-home --system  --home ${KAFKA_HOME} --shell /sbin/nologin --ingroup kafka --gecos "Kafka User" kafka \
    && chmod 755 ${KAFKA_HOME} \
    && mkdir -p ${KAFKA_LOG_DIRS} \
    && mkdir -p ${INTERNAL_ZOOKEEPER_LOGS_PATH} \
    && mkdir -p ${INTERNAL_ZOOKEEPER_DATA_PATH} \
    && mkdir -p ${KAFKA_HOME}/provisioning \
    && chown -R kafka.kafka ${KAFKA_HOME}

# Copy provisioning files
COPY provisioning/* ${KAFKA_HOME}/provisioning/
RUN chmod +x ${KAFKA_HOME}/provisioning/*.sh

# install neccesary packages and kafka
RUN apt-get update && apt-get install -y --no-install-recommends wget gnupg ca-certificates \
    && wget -q "${KAFKA_DOWNLOAD_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    && wget -q https://kafka.apache.org/KEYS \
    && wget -q "${KAFKA_DOWNLOAD_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc" \
    && echo "#### START IMPORTING GPG KEYS ####" \
    && gpg --import KEYS \
    && echo "#### END IMPORTING GPG KEYS ####" \
    && echo "#### START VERIFY GPG KEYS ####" \
    && gpg --verify "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc" \
    && echo "#### END VERIFY GPG KEYS ####" \
    && tar -xv -C ${KAFKA_HOME} --strip-components=1 -f "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    && rm -rf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz*" \
    && chown -R kafka.kafka /opt \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Set the PATH
ENV PATH=$KAFKA_HOME/bin:$PATH

# Exposed ports
EXPOSE ${KAFKA_PORT} ${INTERNAL_ZOOKEEPER_PORT}

VOLUME ["/opt/kafka/config", "/opt/kafka/logs", "/opt/kafka/zookeeper/logs"]

USER kafka
WORKDIR /opt/kafka

# Force any command provision the container
ENTRYPOINT ["provisioning/docker-entrypoint.sh"]

# Default command to run on boot
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
