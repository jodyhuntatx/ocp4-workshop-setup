#!/bin/bash

source ../dap-service.config
source ../conjur_utils.sh

main() {
  oc login -u $CLUSTER_ADMIN
  clean_user_labs
  if [[ "$1" == "clean" ]]; then
    exit 0
  fi
  create_users
  create_secrets_access_clusterrole
  create_lab_namespaces
  create_namespace_root_policies
  grant_user_access_to_dap_cm
  deploy_labadmin
}

#############################
clean_user_labs() {
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))
  do
    uname=$(echo user${unum})
		# delete labadmin deployment
    oc delete -f $uname-dap-labadmin-manifest.yaml -n $uname --ignore-not-found --force=true --grace-period=0
    rm -f $uname-dap-labadmin-manifest.yaml
		# delete user identity
    oc delete -f $uname-create-user-manifest.yaml --ignore-not-found --force=true --grace-period=0
    rm -f $uname-create-user-manifest.yaml
		# delete dap cm rollbinding
    oc delete -f $uname-dap-cm-rolebinding.yaml -n $CYBERARK_NAMESPACE_NAME --ignore-not-found --force=true --grace-period=0
    rm -f $uname-dap-cm-rolebinding.yaml
		# delete namespace admin permissions 
    oc delete -f $uname-manifest.yaml -n $uname --ignore-not-found --force=true --grace-period=0
    rm -f $uname-manifest.yaml $uname-policy.yaml
  done

  rm -f users.htpasswd
}

#############################
# Cleans up existing user authn infrastructure.
delete_users() {
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))
  do
    uname=$(echo user${unum})
    oc delete user $uname --ignore-not-found
    oc delete identity $LAB_HTPASS_PROVIDER:$uname --ignore-not-found
  done
}

#############################
# This function should ONLY BE CALLED IF CLUSTER USERS HAVE NOT ALREADY BEEN CREATED!
#
# Update EXISTING htpasswd file for users
# Doc: https://docs.openshift.com/container-platform/4.4/authentication/identity_providers/configuring-htpasswd-identity-provider.html

create_users() {
  delete_users

  oc get secret $LAB_HTPASS_SECRET -ojsonpath={.data.htpasswd} -n openshift-config | $BASE64D > users.htpasswd
  if [[ $(du -k users.htpasswd | cut -f 1)  == 0 ]]; then
    echo "Password file users.htpasswd is empty."
  else
    echo "users.htpasswd:"
    echo "=============="
    cat ./users.htpasswd
    echo "=============="
    echo
  fi

  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))
  do
    uname=$(echo user${unum})
    passwd=$(echo user${unum})
    htpasswd -B -b users.htpasswd $uname $passwd
    cat ./templates/USER-create-manifest.template.yaml			\
    | sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g"			\
    | sed -e "s#{{ LAB_HTPASS_PROVIDER }}#$LAB_HTPASS_PROVIDER#g"	\
    > $uname-create-user-manifest.yaml
    oc apply -f $uname-create-user-manifest.yaml
  done

  oc create secret generic $LAB_HTPASS_SECRET --from-file=htpasswd=users.htpasswd --dry-run -o yaml -n openshift-config | oc replace -f -
}

#############################
create_secrets_access_clusterrole() {
  oc apply -f ./templates/secrets-access-clusterrole.template.yaml
}

#############################
create_lab_namespaces() {
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))	# apply manifest for namespace and user 
  do
    uname=$(echo user${unum})
    cat ./templates/APP_NAMESPACE-manifest.template.yaml				\
    | sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g" 					\
    | sed -e "s#{{ LAB_HTPASS_PROVIDER }}#$LAB_HTPASS_PROVIDER#g"			\
    | sed -e "s#{{ APP_NAMESPACE_ADMIN }}#$uname#g"					\
    | sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g" 		\
    > ./$uname-manifest.yaml
    oc apply -f ./$uname-manifest.yaml -n $uname
  done
}

#############################
create_namespace_root_policies() {

  export CONJUR_AUTHN_LOGIN=admin
  export CONJUR_AUTHN_API_KEY=$DAP_ADMIN_PASSWORD

  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))        # apply manifest for namespace and user
  do
    uname=$(echo user${unum})
    cat ./templates/APP_NAMESPACE-policy.template.yaml				\
    | sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g"				\
    | sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g"	\
    > ./$uname-policy.yaml
    conjur_append_policy root ./$uname-policy.yaml
    api_key=$(conjur_rotate_api_key user $uname)
    conjur_set_user_password $uname $api_key ${uname}CYBR2@2@
  done
}

#############################
grant_user_access_to_dap_cm() {
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))	# apply manifest for namespace and user 
  do
    uname=$(echo user${unum})
    cat ./templates/dap-cm-rolebinding.template.yaml				\
    | sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g" 				\
    | sed -e "s#{{ APP_NAMESPACE_ADMIN }}#$uname#g"				\
    | sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g" 	\
    > ./$uname-dap-cm-rolebinding.yaml
    oc apply -f ./$uname-dap-cm-rolebinding.yaml -n $CYBERARK_NAMESPACE_NAME
  done
}

#############################
deploy_labadmin() {
  for (( unum=1; unum<=$NUM_ATTENDEES; unum++ ))	# apply manifest for labadmin for each user 
  do
    uname=$(echo user${unum})
						    	# deploy dap config map in APP_NAMESPACE
    oc get cm dap-config -n $CYBERARK_NAMESPACE_NAME -o yaml		\
    | sed "s/namespace: $CYBERARK_NAMESPACE_NAME/namespace: $uname/"	\
    | oc apply -f - -n $uname

    cat ./templates/dap-labadmin-manifest.template.yaml				\
    | sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g"	\
    | sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g"				\
    | sed -e "s#{{ APP_IMAGE }}#$REGISTRY_LABADMIN_IMAGE#g"			\
    | sed -e "s#{{ AUTHENTICATOR_IMAGE }}#$AUTHENTICATOR_IMAGE #g"		\
    > ./$uname-dap-labadmin-manifest.yaml
    oc apply -f ./$uname-dap-labadmin-manifest.yaml -n $uname
  done
}

main "$@"
