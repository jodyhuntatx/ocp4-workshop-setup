#!/bin/bash

PETSTORE_ADDRESS=petstore:8080

echo "Pets in PetDB:"
curl -s $PETSTORE_ADDRESS/pets

echo "Adding Lilah..."
curl -XPOST --data '{ "name": "Lilah" }' -H "Content-Type: application/json" $PETSTORE_ADDRESS/pet
echo "Adding Lev..."
curl -XPOST --data '{ "name": "Uri" }' -H "Content-Type: application/json" $PETSTORE_ADDRESS/pet
echo "Adding Tony..."
curl -XPOST --data '{ "name": "Tony" }' -H "Content-Type: application/json" $PETSTORE_ADDRESS/pet
echo "Adding Gus..."
curl -XPOST --data '{ "name": "Gus" }' -H "Content-Type: application/json" $PETSTORE_ADDRESS/pet

echo "Pets in PetDB:"
curl -s $PETSTORE_ADDRESS/pets
echo
echo
