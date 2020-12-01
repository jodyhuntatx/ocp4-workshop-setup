#!/bin/bash

source ../dap-service.config

main() {
  oc login -u $CLUSTER_ADMIN
  clean_mysql
  if [[ "$1" == "clean" ]]; then
    exit 0
  fi
  deploy_mysql_db
}

########################
clean_mysql() {
  oc delete -f mysql.yaml -n $CYBERARK_NAMESPACE_NAME --ignore-not-found
  rm -f mysql.yaml
}

########################
deploy_mysql_db() {
  oc adm policy add-scc-to-user anyuid -z mysql-db -n $CYBERARK_NAMESPACE_NAME
  cat ./templates/mysql.template.yml                     		\
  | sed "s#{{ MYSQL_IMAGE_NAME }}#$REGISTRY_MYSQL_IMAGE#g"		\
  | sed "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g"	\
  | sed "s#{{ MYSQL_USERNAME }}#$MYSQL_USERNAME#g"              	\
  | sed "s#{{ MYSQL_PASSWORD }}#$MYSQL_PASSWORD#g"              	\
  > ./mysql.yaml
  oc apply -f ./mysql.yaml -n $CYBERARK_NAMESPACE_NAME
}

main "$@"
