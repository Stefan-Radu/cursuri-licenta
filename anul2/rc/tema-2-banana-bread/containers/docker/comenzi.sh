#!/bin/bash
docker-compose exec router bash -c "/elocal/docker/src/bottleneck.sh"
docker-compose exec server bash -c "iperf3 -s -1"
docker-compose exec client bash -c "/elocal/docker/src/capture_stats.sh"
docker-compose exec client bash -c "iperf3 -c 198.10.0.2 -t 60 -C reno"

