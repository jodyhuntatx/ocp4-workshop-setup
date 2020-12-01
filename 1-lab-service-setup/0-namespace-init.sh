#!/bin/bash

source ../dap-service.config

main() {
  oc login -u $CLUSTER_ADMIN
  clean_namespace
  if [[ "$1" == "clean" ]]; then
    exit 0
  fi
  init_namespace
}

########################
clean_namespace() {
  oc delete -f ./$CYBERARK_NAMESPACE_NAME-manifest.yaml -n $CYBERARK_NAMESPACE_NAME --ignore-not-found
  rm -f ./$CYBERARK_NAMESPACE_NAME-manifest.yaml
}

########################
init_namespace() {
  cat ./templates/CYBERARK-manifest.template.yaml					\
  | sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g" 		\
  | sed -e "s#{{ CYBERARK_NAMESPACE_ADMIN }}#$CYBERARK_NAMESPACE_ADMIN#g" 		\
  > ./$CYBERARK_NAMESPACE_NAME-manifest.yaml
  oc apply -f ./$CYBERARK_NAMESPACE_NAME-manifest.yaml -n $CYBERARK_NAMESPACE_NAME

  oc adm policy add-scc-to-user anyuid -z dap-authn-service -n $CYBERARK_NAMESPACE_NAME
}

main "$@"
