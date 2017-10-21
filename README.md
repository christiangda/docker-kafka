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
