#!/bin/bash
docker-compose -f ./docker-compose.build.yml down --remove-orphans
make build