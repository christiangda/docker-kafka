# docker-kafka
Just another Apache Kafka docker image

### Download
```bash
docker pull christiangda/kafka
```

### see config files provisioned

Default configuration
```bash
docker run -t -i --rm -p 9092:9092 christiangda/kafka cat config/server.properties
```

When you want to check if your env var finish in the config file
```bash
docker run -t -i --rm -p 9092:9092 -e "KAFKA__LOG_RETENTION_BYTES=20148" christiangda/kafka cat config/server.properties
```

```bash
docker network create kafka-net

docker run --rm \
  --tty \
  --interactive \
  --hostname zookeeper-01 \
  --publish 2181:2181 \
  christiangda/kafka bin/zookeeper-server-start.sh config/zookeeper.properties
```
```bash
docker run --rm \
  --tty \
  --interactive \
  --hostname kafka-01 \
  --publish 9092:9092 \
  --env "KAFKA__ZOOKEEPER_CONNECT=127.0.0.1:2181" \
  christiangda/kafka bin/kafka-server-start.sh config/server.properties
```
