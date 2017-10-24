# docker-kafka
Just another Apache Kafka docker image

### Download
```bash
docker pull christiangda/kafka
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
