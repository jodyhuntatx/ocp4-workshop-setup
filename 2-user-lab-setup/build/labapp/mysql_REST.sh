#!/bin/bash 

# name of secrets to retrieve from Conjur
DB_UNAME_ID=LabVault/Labs/LabSafe1/MySQL/username
DB_PWD_ID=LabVault/Labs/LabSafe1/MySQL/password

main() {
  AUTHN_TOKEN=$(cat $CONJUR_AUTHN_TOKEN_FILE | base64 | tr -d '\r\n')

  DB_UNAME_ID=$(urlify "$DB_UNAME_ID")
  DB_PWD_ID=$(urlify "$DB_PWD_ID")

  DB_UNAME=$(curl -s -k \
	--request GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Token token=\"$AUTHN_TOKEN\"" \
        $CONJUR_APPLIANCE_URL/secrets/$CONJUR_ACCOUNT/variable/$DB_UNAME_ID)

  DB_PWD=$(curl -s -k \
	--request GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Token token=\"$AUTHN_TOKEN\"" \
        $CONJUR_APPLIANCE_URL/secrets/$CONJUR_ACCOUNT/variable/$DB_PWD_ID)

  echo
  echo "The retrieved values are:"
  echo "  DB_UNAME: $DB_UNAME"
  echo "  DB_PWD: $DB_PWD"
  echo

  set -x
  mysql -h $DB_HOSTNAME -u $DB_UNAME --password=$DB_PWD test_app
}

################
# URLIFY - converts '/' and ':' in input string to hex equivalents
# in: $1 - string to convert
# out: URLIFIED - converted string in global variable
urlify() {
        local str=$1; shift
        str=$(echo $str | sed 's= =%20=g')
        str=$(echo $str | sed 's=/=%2F=g')
        str=$(echo $str | sed 's=:=%3A=g')
        echo $str
}

main "$@"

exit
