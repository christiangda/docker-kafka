ARG CONTAINER_JAVA_VERSION=9
FROM openjdk:${CONTAINER_JAVA_VERSION}-jre-slim

# Arguments from docker build proccess
ARG SCALA_VERSION
ARG KAFKA_DOWNLOAD_MIRROR
ARG KAFKA_VERSION

# Environment variables
ENV SCALA_VERSION=${SCALA_VERSION:-2.11} \
    KAFKA_VERSION=${KAFKA_VERSION:-1.0.2} \
    KAFKA_DOWNLOAD_MIRROR=${KAFKA_DOWNLOAD_MIRROR:-https://dist.apache.org/repos/dist/release/kafka} \
    KAFKA_USER="kafka" \
    KAFKA_GROUP="kafka" \
    KAFKA_HOME="/opt/kafka" \
    INTERNAL_KAFKA_LOG_DIRS="/opt/kafka/logs" \
    INTERNAL_KAFKA_PORT=9092 \
    INTERNAL_KAFKA_JMX_PORT=9999 \
    INTERNAL_ZOOKEEPER_PORT=2181 \
    INTERNAL_KAFKA_CONFIG_PATH="/opt/kafka/config" \
    INTERNAL_ZOOKEEPER_LOGS_PATH="/opt/kafka/zookeeper/logs" \
    INTERNAL_ZOOKEEPER_DATA_PATH="/opt/kafka/zookeeper/data" \
    DEBIAN_FRONTEND=noninteractive

# Container's Labels
LABEL maintainer="Christian González Di Antonio <christiangda@gmail.com>" \
      org.opencontainers.image.authors="Christian González Di Antonio <christiangda@gmail.com>" \
      org.opencontainers.image.url="https://github.com/christiangda/docker-kafka" \
      org.opencontainers.image.documentation="https://github.com/christiangda/docker-kafka" \
      org.opencontainers.image.source="https://github.com/christiangda/docker-kafka" \
      org.opencontainers.image.version=${CONTAINER_JAVA_VERSION}-${SCALA_VERSION}-${KAFKA_VERSION} \
      org.opencontainers.image.vendor="Christian González Di Antonio <christiangda@gmail.com>" \
      org.opencontainers.image.licenses="Apache License Version 2.0" \
      org.opencontainers.image.title="Apache Kafka" \
      org.opencontainers.image.description="Just another Apache Kafka docker image"

# Create service's user
RUN addgroup --gid 1000 ${KAFKA_GROUP} \
    && mkdir -p ${KAFKA_HOME}/bin \
    && adduser --uid 1000 --no-create-home --system  --home ${KAFKA_HOME} --shell /sbin/nologin --ingroup ${KAFKA_GROUP} --gecos "Kafka User" ${KAFKA_USER} \
    && chmod 755 ${KAFKA_HOME} \
    && mkdir -p ${INTERNAL_KAFKA_LOG_DIRS} \
    && mkdir -p ${INTERNAL_ZOOKEEPER_LOGS_PATH} \
    && mkdir -p ${INTERNAL_ZOOKEEPER_DATA_PATH} \
    && mkdir -p ${KAFKA_HOME}/provisioning \
    && chown -R kafka.kafka ${KAFKA_HOME}

# Copy provisioning files
COPY provisioning/* ${KAFKA_HOME}/provisioning/
RUN chmod +x ${KAFKA_HOME}/provisioning/*.sh

# install neccesary packages and kafka
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
    krb5-user \
    libterm-readline-gnu-perl \
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
EXPOSE ${INTERNAL_KAFKA_PORT} ${INTERNAL_ZOOKEEPER_PORT} ${INTERNAL_KAFKA_JMX_PORT}

VOLUME "/tmp" ${INTERNAL_KAFKA_CONFIG_PATH} ${INTERNAL_KAFKA_LOG_DIRS} ${INTERNAL_ZOOKEEPER_DATA_PATH} ${INTERNAL_ZOOKEEPER_LOGS_PATH}

USER ${KAFKA_USER}
WORKDIR ${KAFKA_HOME}

# Force any command provision the container
ENTRYPOINT ["provisioning/docker-entrypoint.sh"]

# Default command to run on boot
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
