# Using docker-machine + docker-swarm

[Create a Cluster in Docker Swarm](https://docs.docker.com/get-started/part4/#create-a-cluster)
```
docker-machine create --driver virtualbox --virtualbox-cpu-count "1" --virtualbox-memory "2048" manager-01
docker-machine create --driver virtualbox --virtualbox-cpu-count "1" --virtualbox-memory "2048" worker-01
docker-machine create --driver virtualbox --virtualbox-cpu-count "1" --virtualbox-memory "2048" worker-02
docker-machine create --driver virtualbox --virtualbox-cpu-count "1" --virtualbox-memory "2048" worker-03
```

```
docker-machine ls
NAME         ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
manager-01   -        virtualbox   Running   tcp://192.168.99.100:2376           v17.11.0-ce
worker-01    -        virtualbox   Running   tcp://192.168.99.101:2376           v17.11.0-ce
worker-02    -        virtualbox   Running   tcp://192.168.99.102:2376           v17.11.0-ce
worker-03    -        virtualbox   Running   tcp://192.168.99.103:2376           v17.11.0-ce

```

## INITIALIZE THE SWARM AND ADD NODES
```
docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"
```

### Create Swarm master node
```
docker-machine ssh manager-01 "docker swarm init --advertise-addr $(docker-machine ip manager-01)"
Swarm initialized: current node (zby7j1erqmgzjyvnf8kda5nrc) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-4wnwin0w51gx8zbqnqiebeb3onu4nubzb29ko6oir17qktr81i-1hspuo6eakfbnqmtsjaese4yn 192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Add additional nodes
```
docker-machine ssh worker-01 "docker swarm join --token SWMTKN-1-4wnwin0w51gx8zbqnqiebeb3onu4nubzb29ko6oir17qktr81i-1hspuo6eakfbnqmtsjaese4yn 192.168.99.100:2377"
docker-machine ssh worker-02 "docker swarm join --token SWMTKN-1-4wnwin0w51gx8zbqnqiebeb3onu4nubzb29ko6oir17qktr81i-1hspuo6eakfbnqmtsjaese4yn 192.168.99.100:2377"
docker-machine ssh worker-03 "docker swarm join --token SWMTKN-1-4wnwin0w51gx8zbqnqiebeb3onu4nubzb29ko6oir17qktr81i-1hspuo6eakfbnqmtsjaese4yn 192.168.99.100:2377"
```

Verify the swarm cluster
```
docker-machine ssh manager-01 "docker node ls"
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
p0mf491t3q965ar3hr0w5klgo *   manager-01          Ready               Active              Leader
x5nclscr07w81b2phm6jeqz4l     worker-01           Ready               Active
1975635r7oj2fcfgdbbe4nm4d     worker-02           Ready               Active
3f7nze9eluoxdr627gdqtdoe3     worker-03           Ready               Active
```
### Configure a `docker-machine` shell to the swarm manager

```
docker-machine env manager-01
eval $(docker-machine env manager-01)
```

Verify
```
docker-machine ls
NAME         ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
manager-01   *        virtualbox   Running   tcp://192.168.99.100:2376           v17.11.0-ce
worker-01    -        virtualbox   Running   tcp://192.168.99.101:2376           v17.11.0-ce
worker-02    -        virtualbox   Running   tcp://192.168.99.102:2376           v17.11.0-ce
worker-03    -        virtualbox   Running   tcp://192.168.99.103:2376           v17.11.0-ce
```

Deploy pour cluster
```
docker stack deploy -c docker-compose.yml kafka-cluster
```

```
docker stack ps kafka-cluster

watch docker stack ps kafka-cluster
```

See containers logs

```
docker service logs kafka-cluster_zk-01
docker service logs kafka-cluster_zk-01
docker service logs kafka-cluster_zk-01
docker service logs kafka-cluster_kafka-01
docker service logs kafka-cluster_kafka-02
docker service logs kafka-cluster_kafka-03
```

### Using a container to connect as a kafka client
```
docker service create --replicas 1 --name kafka-client  --network kafka-cluster_kafka-net christiangda/kafka:1.0.0 sleep 3600
docker service ps kafka-client
```

## Docker Swarm visualizer

Enter to: `http://192.168.99.100:8080/` and you will see something like this:

![Kafka cluster in Docker Swarm Cluster](https://github.com/christiangda/docker-kafka/blob/master/docs/imgs/swarm-kafka-cluster.png)
