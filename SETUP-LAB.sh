#!/bin/bash
pushd ./1-lab-service-setup
  ./0-namespace-init.sh 
  ./1-master-deploy.sh 
  ./2-mysqldb-deploy.sh 
popd
pushd ./2-user-lab-setup
./0-user-lab-setup.sh 
popd
