#!/bin/bash -e
source ../../../dap-service.config
docker build -t $REGISTRY_LABAPP_IMAGE .
docker push $REGISTRY_LABAPP_IMAGE
