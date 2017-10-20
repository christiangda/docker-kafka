FROM openjdk:8-jre-alpine

MAINTAINER Christian González <christiangda@gmail.com>

# Arguments from docker build proccess
ARG SCALA_VERSION
ARG KAFKA_DOWNLOAD_MIRROR
ARG KAFKA_VERSION

# Default values
ENV SCALA_VERSION ${SCALA_VERSION:-2.11}
ENV KAFKA_VERSION ${KAFKA_VERSION:-0.11.0.1}
ENV KAFKA_DOWNLOAD_MIRROR ${KAFKA_DOWNLOAD_MIRROR:-http://apache.mirrors.pair.com}

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

RUN addgroup -g 1000 kafka \
    && mkdir -p /opt/kafka \
    && adduser -u 1000 -S -D -G kafka -h /opt/kafka -s /sbin/nologin -g "Kafka user" kafka \
    && chmod 755 /opt/kafka \
    && chown -R kafka.kafka /opt/kafka

RUN apk --no-cache --update add wget bash \
    && wget -q -O - "$KAFKA_DOWNLOAD_MIRROR"/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz | tar -xzf - -C /opt/kafka --strip 1 \
    && chown -R kafka.kafka /opt \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# Environment variables
ENV container docker
ENV KAFKA_HOME "/opt/kafka"
ENV PATH $KAFKA_HOME/bin:$PATH
ENV KAFKA_LOG_DIRS "/var/log/kafka"

# Exposed ports
EXPOSE 2181 9092

VOLUME ["/opt/kafka/config"]

USER kafka
WORKDIR /opt/kafka

# Default command to run on boot
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
