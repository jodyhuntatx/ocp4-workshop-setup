#!/bin/bash

# Assumes k8s authentication success and access token is 
# provided at $CONJUR_AUTHN_TOKEN_FILE

all_set=true
if [[ -z "${CONJUR_MASTER_URL}" ]]; then
  echo "You must set the CONJUR_MASTER_URL env var."
  all_set=false
fi
if [[ -z "${CONJUR_ACCOUNT}" ]]; then
  echo "You must set the CONJUR_ACCOUNT env var."
  all_set=false
fi
if [[ -z "${CONJUR_AUTHN_TOKEN_FILE}" ]]; then
  echo "You must set the CONJUR_AUTHN_TOKEN_FILE env var."
  all_set=false
fi
if ! $all_set; then
  exit -1
fi

if [[ $# < 2 ]] ; then
    printf "\nUsage: %s <policy-branch-id> <policy-filename> [ delete | replace ]\n" $0
    printf "\nExamples:\n"
    printf "\t$> %s root /tmp/policy.yml\n" $0
    printf "\t$> %s dev/my-app /tmp/policy.yml\n" $0
    printf "\nDefault is append mode, unless 'delete' or 'replace' is specified\n"
    exit -1
fi

policy_branch=$1
policy_file=$2
LOAD_MODE="POST"

if [[ $# == 3 ]]; then
    case $3 in
      delete)   LOAD_MODE="PATCH"
		;;
      replace)  LOAD_MODE="PUT"
		;;
      *)	printf "\nSpecify 'delete' or 'replace' as load mode options.\n\n"
		exit -1
    esac
fi

AUTHN_TOKEN=$(cat $CONJUR_AUTHN_TOKEN_FILE | base64 | tr -d '\r\n')
curl -sk \
     -H "Content-Type: application/json" \
     -H "Authorization: Token token=\"$AUTHN_TOKEN\"" \
     -X $LOAD_MODE -d "$(< $policy_file)" \
     $CONJUR_MASTER_URL/policies/$CONJUR_ACCOUNT/policy/$policy_branch
echo
