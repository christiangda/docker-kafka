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
