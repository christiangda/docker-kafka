FROM openjdk:8-jre-alpine

MAINTAINER Christian González <christiangda@gmail.com>

# Arguments from docker build proccess
ARG SCALA_VERSION
ARG KAFKA_DOWNLOAD_MIRROR
ARG KAFKA_VERSION

# Environment variables
ENV container=docker \
    SCALA_VERSION=${SCALA_VERSION:-2.11} \
    KAFKA_VERSION=${KAFKA_VERSION:-0.11.0.1} \
    KAFKA_DOWNLOAD_MIRROR=${KAFKA_DOWNLOAD_MIRROR:-http://apache.mirrors.pair.com} \
    KAFKA_HOME="/opt/kafka" \
    KAFKA_DATA_PATH="/opt/kafka/data" \
    KAFKA__LOG_DIRS="/opt/kafka/logs" \
    KAFKA__PORT=9092

ENV PATH=$KAFKA_HOME/bin:$PATH

# Container's Labels
LABEL Description "Apache Kafka docker image" \
      Vendor "Christian González" \
      Name "Apache Kafka" \
      Version ${SCALA_VERSION}-${KAFKA_VERSION}

LABEL Build "docker build --no-cache --rm \
            --build-arg SCALA_VERSION=2.11 \
            --build-arg KAFKA_VERSION=0.11.0.1 \
            --build-arg KAFKA_DOWNLOAD_MIRROR=http://apache.mirrors.pair.com \
            --tag christiangda/kafka:2.11-0.11.0.1 \
            --tag christiangda/kafka:latest \
            --tag christiangda/kafka:canary ." \
      Run "docker run --rm -t -i -h "kafka-01" christiangda/kafka" \
      Connect "docker exec -ti <container id from 'docker ps' command> /bin/bash"

# Create service's user
RUN addgroup -g 1000 kafka \
    && mkdir -p ${KAFKA_HOME}/bin \
    && adduser -u 1000 -S -D -G kafka -h ${KAFKA_HOME} -s /sbin/nologin -g "Kafka user" kafka \
    && chmod 755 ${KAFKA_HOME} \
    && mkdir -p ${KAFKA__LOG_DIRS} \
    && mkdir -p ${KAFKA_DATA_PATH} \
    && mkdir -p ${KAFKA_HOME}/provisioning \
    && chown -R kafka.kafka ${KAFKA_HOME}

COPY kafka-docker-cmd.sh ${KAFKA_HOME}/bin/
COPY provisioning/* ${KAFKA_HOME}/provisioning/

RUN apk --no-cache --update add wget bash \
    && wget -q -O - "${KAFKA_DOWNLOAD_MIRROR}"/kafka/"${KAFKA_VERSION}"/kafka_"${SCALA_VERSION}"-"${KAFKA_VERSION}".tgz | tar -xzf - -C ${KAFKA_HOME} --strip 1 \
    && chown -R kafka.kafka /opt \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN chmod +x ${KAFKA_HOME}/bin/kafka-docker-cmd.sh \
    && chmod +x ${KAFKA_HOME}/provisioning/*.sh \
    && ${KAFKA_HOME}/provisioning/server-properties.sh

# Exposed ports
EXPOSE ${KAFKA__PORT}

VOLUME ["/opt/kafka/config", "/opt/kafka/logs", "/opt/kafka/data"]

USER kafka
WORKDIR /opt/kafka

# Default command to run on boot
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
