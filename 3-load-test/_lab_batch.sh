#!/bin/bash

source ../dap-service.config
source ../conjur_utils.sh

main() {
  if [[ $# != 2 ]]; then
    echo "Usage: $0 [ apply | delete ] [ 1-sidecar | 2-initcontainer | 3-k8sprovider-init | 4-secretless ]"
    exit -1
  fi

  lab_cmd=$1
  lab_name=$2

  case $lab_cmd in
    apply)
	apply_lab $lab_name
	;;
    delete)
	delete_lab $lab_name
	;;
    *)
	echo "Usage: $0 [ apply | delete ] [ 1-sidecar | 2-initcontainer | 3-k8sprovider-init | 4-secretless ]"
	exit -1
	;;
  esac
}

########################
apply_lab() {
  local lab_name=$1
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))
  do
    uname=$(echo user${unum})
    oc project $uname
    oc exec labadmin -c labadmin -- bash -c "cd $lab_name; ./labctl y; ./labctl a"
  done
}

########################
delete_lab() {
  local lab_name=$1
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))
  do
    uname=$(echo user${unum})
    oc project $uname
    oc exec labadmin -c labadmin -- bash -c "cd $lab_name; ./labctl d"
  done
}

main "$@"
