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
    KAFKA_DOWNLOAD_MIRROR=${KAFKA_DOWNLOAD_MIRROR:-"https://dist.apache.org/repos/dist/release/kafka"} \
    KAFKA_HOME="/opt/kafka" \
    KAFKA_LOG_DIRS="/opt/kafka/logs" \
    KAFKA_PORT=9092 \
    INTERNAL_ZOOKEEPER_PORT=2181

# Container's Labels
LABEL Description "Apache Kafka docker image" \
      Vendor "Christian González" \
      Name "Apache Kafka" \
      Version ${SCALA_VERSION}-${KAFKA_VERSION}

LABEL Build "docker build --no-cache --rm \
            --build-arg SCALA_VERSION=2.11 \
            --build-arg KAFKA_VERSION=0.11.0.1 \
            --tag christiangda/kafka:2.11-0.11.0.1 \
            --tag christiangda/kafka:latest \
            --tag christiangda/kafka:canary ." \
      Run "docker run --tty --interactive --rm --name "kafka-01" christiangda/kafka" \
      Connect "docker exec --tty --interactive <container id from 'docker ps' command> /bin/bash"

# Create service's user
RUN addgroup -g 1000 kafka \
    && mkdir -p ${KAFKA_HOME}/bin \
    && adduser -u 1000 -S -D -G kafka -h ${KAFKA_HOME} -s /sbin/nologin -g "Kafka user" kafka \
    && chmod 755 ${KAFKA_HOME} \
    && mkdir -p ${KAFKA_LOG_DIRS} \
    && mkdir -p ${KAFKA_HOME}/provisioning \
    && chown -R kafka.kafka ${KAFKA_HOME}

# Copy provisioning files
COPY provisioning/* ${KAFKA_HOME}/provisioning/
RUN chmod +x ${KAFKA_HOME}/provisioning/*.sh

RUN apk --no-cache --update add wget bash gnupg krb5-libs\
    && wget -q "${KAFKA_DOWNLOAD_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    && wget -q "${KAFKA_DOWNLOAD_MIRROR}/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.md5" \
    && echo "#### START VERIFY CHECKSUM ####" \
    && gpg --print-md MD5 "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" 2>/dev/null && cat "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.md5" \
    && echo "#### END VERIFY CHECKSUM ####" \
    && tar -xv -C ${KAFKA_HOME} --strip-components=1 -f "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    && rm -rf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz*" \
    && chown -R kafka.kafka /opt \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# Set the PATH
ENV PATH=$KAFKA_HOME/bin:$PATH

# Exposed ports
EXPOSE ${KAFKA_PORT} ${INTERNAL_ZOOKEEPER_PORT}

VOLUME ["/opt/kafka/config", "/opt/kafka/logs", "/opt/kafka/data"]

USER kafka
WORKDIR /opt/kafka

# Force any command provision the container
ENTRYPOINT ["provisioning/docker-entrypoint.sh"]

# Default command to run on boot
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
