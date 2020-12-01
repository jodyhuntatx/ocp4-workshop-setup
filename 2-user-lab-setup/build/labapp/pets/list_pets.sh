#!/bin/bash

PETSTORE_ADDRESS=petstore:8080

echo "Listing all pets..."
curl $PETSTORE_ADDRESS/pets
echo
echo
