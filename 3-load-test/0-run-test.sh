#!/bin/bash

main() {
  ./_lab_batch.sh apply 4-secretless
}

# start labs for all users
start_all() {
  ./_lab_batch.sh apply 1-sidecar
  ./_lab_batch.sh apply 2-initcontainer
  ./_lab_batch.sh apply 3-k8sprovider-init
  ./_lab_batch.sh apply 4-secretless
}

# delete labs for all users
delete_all() {
  ./_lab_batch.sh delete 1-sidecar
  ./_lab_batch.sh delete 2-initcontainer
  ./_lab_batch.sh delete 3-k8sprovider-init
  ./_lab_batch.sh delete 4-secretless
}

main "$@"
