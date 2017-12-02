# Build Procedure

## Tags: openjdk-8-2.10-0.10.2.1, 2.10-0.10.2.1

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.10 \
  --build-arg KAFKA_VERSION=0.10.2.1 \
  --tag christiangda/kafka:openjdk-8-2.10-0.10.2.1 \
  --tag christiangda/kafka:2.10-0.10.2.1 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:2.10-0.10.2.1 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.10-0.10.2.1
docker push christiangda/kafka:2.10-0.10.2.1
```


## Tags: openjdk-8-2.11-0.10.2.1, 2.11-0.10.2.1, 0.10.2.1 (Default)

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.11 \
  --build-arg KAFKA_VERSION=0.10.2.1 \
  --tag christiangda/kafka:openjdk-8-2.11-0.10.2.1 \
  --tag christiangda/kafka:2.11-0.10.2.1 \
  --tag christiangda/kafka:0.10.2.1 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:0.10.2.1 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.11-0.10.2.1
docker push christiangda/kafka:2.11-0.10.2.1
docker push christiangda/kafka:0.10.2.1
```

## Tags: openjdk-8-2.12-0.10.2.1, 2.12-0.10.2.1

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.12 \
  --build-arg KAFKA_VERSION=0.10.2.1 \
  --tag christiangda/kafka:openjdk-8-2.12-0.10.2.1 \
  --tag christiangda/kafka:2.12-0.10.2.1 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:2.12-0.10.2.1 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.12-0.10.2.1
docker push christiangda/kafka:2.12-0.10.2.1
```

## Tags: openjdk-8-2.11-0.11.0.2, 2.11-0.11.0.2, 0.11.0.2 (Default)

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.11 \
  --build-arg KAFKA_VERSION=0.11.0.2 \
  --tag christiangda/kafka:openjdk-8-2.11-0.11.0.2 \
  --tag christiangda/kafka:2.11-0.11.0.2 \
  --tag christiangda/kafka:0.11.0.2 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:0.11.0.2 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.11-0.11.0.2
docker push christiangda/kafka:2.11-0.11.0.2
docker push christiangda/kafka:0.11.0.2
```

## Tags: openjdk-8-2.12-0.11.0.2, 2.12-0.11.0.2

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.12 \
  --build-arg KAFKA_VERSION=0.11.0.2 \
  --tag christiangda/kafka:openjdk-8-2.12-0.11.0.2 \
  --tag christiangda/kafka:2.12-0.11.0.2 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:2.12-0.11.0.2 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.12-0.11.0.2
docker push christiangda/kafka:2.12-0.11.0.2
```

## Tags: openjdk-8-2.11-1.0.0

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.11 \
  --build-arg KAFKA_VERSION=1.0.0 \
  --tag christiangda/kafka:openjdk-8-2.11-1.0.0 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:openjdk-8-2.11-1.0.0 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.11-1.0.0
```

## Tags: openjdk-8-2.12-1.0.0

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=8 \
  --build-arg SCALA_VERSION=2.12 \
  --build-arg KAFKA_VERSION=1.0.0 \
  --tag christiangda/kafka:openjdk-8-2.12-1.0.0 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:openjdk-8-2.12-1.0.0 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-8-2.12-1.0.0
```

## Tags: openjdk-9-2.11-1.0.0, 2.11-1.0.0, 1.0.0 (Default)

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=9 \
  --build-arg SCALA_VERSION=2.11 \
  --build-arg KAFKA_VERSION=1.0.0 \
  --tag christiangda/kafka:openjdk-9-2.11-1.0.0 \
  --tag christiangda/kafka:2.11-1.0.0 \
  --tag christiangda/kafka:1.0.0 \
  --tag christiangda/kafka:latest .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:1.0.0 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-9-2.11-1.0.0
docker push christiangda/kafka:2.11-1.0.0
docker push christiangda/kafka:1.0.0
docker push christiangda/kafka:latest
```

## Tags: openjdk-9-2.12-1.0.0, 2.12-1.0.0

```script
docker build --no-cache --rm \
  --build-arg CONTAINER_JAVA_VERSION=9 \
  --build-arg SCALA_VERSION=2.12 \
  --build-arg KAFKA_VERSION=1.0.0 \
  --tag christiangda/kafka:openjdk-9-2.12-1.0.0 \
  --tag christiangda/kafka:2.12-1.0.0 .

docker run --tty --interactive --rm --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  christiangda/kafka:2.12-1.0.0 WITH_INTERNAL_ZOOKEEPER bin/kafka-server-start.sh config/server.properties

docker push christiangda/kafka:openjdk-9-2.12-1.0.0
docker push christiangda/kafka:2.12-1.0.0
```
