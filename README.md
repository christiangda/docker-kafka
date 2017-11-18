# docker-kafka

Just another Apache Kafka docker image

[Dockerhub repo](https://hub.docker.com/r/christiangda/kafka/)
[Github repo](https://github.com/christiangda/docker-kafka)

Docs: Work in Progress (WIP)!

### Table of Contents

1. [Description - What the container does and why it is useful](#description)
2. [Setup - The basics of getting started with this docker image](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with this Container](#beginning-with-this-container)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Development - Guide for contributing to the module](#development)
7. [Authors - Who is contributing to does it](#authors)
8. [License](#license)

# Description

# Setup

## Setup Requirements

Download

```bash
docker pull christiangda/kafka
```

## Beginning with this container

```bash
docker run --tty --interactive --rm \
  --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties
```

# Usage

## Using its internal Apache Zookeeper

```bash
docker run --tty --interactive --rm \
  --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties
```

### see config files provisioned
using the internal zookeeper daemon
```bash
docker run --tty --interactive --rm \
  --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker run --tty --interactive --rm \
  --name client \
  --link kafka \
  christiangda/kafka bin/kafka-topics.sh --create --zookeeper kafka:2181 --replication-factor 1 --partitions 1 --topic test

docker run --tty --interactive --rm \
  --name client \
  --link kafka \
  christiangda/kafka bin/kafka-topics.sh --list --zookeeper kafka:2181

docker run --tty --interactive --rm \
  --name client \
  --link kafka \
  christiangda/kafka bin/kafka-console-producer.sh --broker-list kafka:9092 --topic test

docker run --tty --interactive --rm \
  --name client \
  --link kafka \
  christiangda/kafka bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic test --from-beginning
```

Multi-Broker
```bash
docker run --tty --interactive --rm \
  --name zk-01 \
  --publish 2181:2181 \
  zookeeper

docker run --tty --interactive --rm \
  --name kafka-01 \
  --publish 9092:9092 \
  --env SERVER__ZOOKEEPER_CONNECT=zk-01 \
  --env SERVER__BROKER_ID=1 \
  --link zk-01 \
  christiangda/kafka bin/kafka-server-start.sh config/server.properties

docker run --tty --interactive --rm \
  --name kafka-02 \
  --publish 9093:9092 \
  --env SERVER__ZOOKEEPER_CONNECT=zk-01 \
  --env SERVER__BROKER_ID=2 \
  --link zk-01 \
  --link kafka-01 \
  christiangda/kafka bin/kafka-server-start.sh config/server.properties

docker run --tty --interactive --rm \
  --name kafka-03 \
  --publish 9094:9092 \
  --env SERVER__ZOOKEEPER_CONNECT=zk-01 \
  --env SERVER__BROKER_ID=3 \
  --link zk-01 \
  --link kafka-01 \
  --link kafka-02 \
  christiangda/kafka bin/kafka-server-start.sh config/server.properties

docker run --tty --interactive --rm \
  --name client \
  --link zk-01 \
  christiangda/kafka bin/kafka-topics.sh --create --zookeeper zk-01:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic

docker run --tty --interactive --rm \
  --name client \
  --link zk-01 \
  christiangda/kafka bin/kafka-topics.sh --describe --zookeeper zk-01:2181 --topic my-replicated-topic

```

Default configuration
```bash
docker run -t -i --rm -e "SERVER__LOG_RETENTION_BYTES=20148" christiangda/kafka cat config/server.properties
docker run -t -i --rm -p 9092:9092 christiangda/kafka bin/kafka-server-start.sh config/server.properties
```

When you want to check if your env var finish in the config file
```bash
docker run -t -i --rm -p 9092:9092 -e "SERVER__LOG_RETENTION_BYTES=20148" christiangda/kafka cat config/server.properties
```

```bash
docker network create kafka-net

docker run --rm \
  --tty \
  --interactive \
  --hostname kafka-01 \
  --publish 2181:2181 \
  --publish 9092:9092 \
  christiangda/kafka WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties
```
```bash
docker run --rm \
  --tty \
  --interactive \
  --hostname kafka-01 \
  --publish 9092:9092 \
  --env "SERVER__ZOOKEEPER_CONNECT=127.0.0.1:2181" \
  christiangda/kafka bin/kafka-server-start.sh config/server.properties
```

Using docker machine+swarm
```bash
docker stack deploy -c docker-compose.yml kafka-cluster
docker stack ps spark-cluster
docker stack rm kafka-cluster
```

# Development

If you want to cooperate with this project, please visit [my Github Repo](https://github.com/christiangda/docker-kafka) and fork it, then made your own
chagest and prepare a git pull request

To build this container, you can execute the following command

```script
git clone https://github.com/christiangda/docker-kafka
cd docker-kafka/
docker build --no-cache --rm --tag <your name>/storm
```

the parametrized's procedure is
```script
git clone https://github.com/christiangda/docker-kafka
cd docker-kafka/
docker build --no-cache --rm \
            --build-arg SCALA_VERSION=2.11 \
            --build-arg KAFKA_VERSION=0.11.0.1 \
            --tag <your name>/kafka:2.11-0.11.0.1 \
            --tag <your name>/kafka:latest .
```

# Authors

[Christian González](https://github.com/christiangda)


## License

This module is released under the Apache License Version 2.0:

* [http://www.apache.org/licenses/LICENSE-2.0.html](http://www.apache.org/licenses/LICENSE-2.0.html)
