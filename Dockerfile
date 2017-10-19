FROM openjdk:8-jre-alpine

MAINTAINER Christian González <christiangda@gmail.com>

# Arguments from docker build proccess
ARG SCALA_MIRROR
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
            --tag christiangda/kafka:3.4.9 \
            --tag christiangda/kafka:latest \
            --tag christiangda/kafka:canary ." \
      Run "docker run --rm -ti -h "kafka-01" christiangda/kafka" \
      Connect "docker exec -ti <container id from 'docker ps' command> /bin/bash"

# Update and install
RUN apk --no-cache --update add wget bash \
    && mkdir /opt \
    && wget -q -O - $KAFKA_DOWNLOAD_MIRROR/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar -xzf - -C /opt \
    && mv /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION /opt/kafka \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN mkdir -p /var/log/kafka

# Environment variables
ENV container docker
ENV KAFKA_HOME "/opt/kafka"
ENV PATH $KAFKA_HOME/bin:$PATH
ENV KAFKA_LOG_DIRS "/var/log/kafka"

# Exposed ports
EXPOSE 2181 9092

WORKDIR /opt/kafka

VOLUME ["/opt/kafka/conf"]

ENTRYPOINT ["kafka_docker.sh"]
CMD ["start-foreground"]
