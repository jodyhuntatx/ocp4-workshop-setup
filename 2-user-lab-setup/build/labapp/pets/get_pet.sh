#!/bin/bash
if [[ $# < 1 ]]; then
  echo "Usage: $0 <pet-number>"
  exit -1
fi
PET_NUMBER=$1

PETSTORE_ADDRESS=petstore:8080

echo "Getting pet number $1..."
curl $PETSTORE_ADDRESS/pet/$1
echo
echo
