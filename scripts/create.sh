#!/bin/bash

podman create -ti --name dst-server \
  -p 11000:11000/udp \
  -p 11001:11001/udp \
  --mount=type=bind,source=./data,destination=/root/.klei/DoNotStarveTogether/ \
  localhost/dst:latest
