#!/bin/bash
if [[ $# < 1 ]]; then
  echo "Usage: $0 <pet-number>"
  exit -1
fi
PET_NUMBER=$1

PETSTORE_ADDRESS=petstore:8080

echo
./list_pets.sh

echo "Deleting pet number $PET_NUMBER.."
curl -XDELETE $PETSTORE_ADDRESS/pet/$PET_NUMBER

echo
./list_pets.sh
