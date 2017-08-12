#!/bin/bash

# creates the volumes needed for persistent storage
docker volume create --name unifi-usr_lib_unifi_data
docker volume create --name unifi-usr_lib_unifi_work
docker volume create --name unifi-var_lib_unifi
docker volume create --name unifi-var_run_unifi
docker volume create --name unifi-var_log_unifi

# creates the docker service, named "unifi"
docker service create \
  --name unifi \
  --publish 8080:8080/tcp \
  --publish 8081:8081/tcp \
  --publish 8443:8443/tcp \
  --publish 8843:8843/tcp \
  --publish 8880:8880/tcp \
  --publish 3468:3478/udp \
  --replicas 1 \
  --mount type=volume,source=unifi-usr_lib_unifi_data,destination=/usr/lib/unifi/data \
  --mount type=volume,source=unifi-usr_lib_unifi_work,destination=/usr/lib/unifi/work \
  --mount type=volume,source=unifi-var_lib_unifi,destination=/var/lib/unifi \
  --mount type=volume,source=unifi-var_run_unifi,destination=/var/run/unifi \
  --mount type=volume,source=unifi-var_log_unifi,destination=/var/log/unifi \
  reverie/armhf-unifi-5:latest
