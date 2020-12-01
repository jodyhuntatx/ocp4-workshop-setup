#!/bin/bash
source ../../../dap-service.config

docker build . -t $REGISTRY_LABADMIN_IMAGE
docker push $REGISTRY_LABADMIN_IMAGE
