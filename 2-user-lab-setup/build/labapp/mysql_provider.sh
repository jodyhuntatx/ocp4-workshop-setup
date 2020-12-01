#!/bin/bash
DB_UNAME=$(cat /etc/secret-volume/username)
DB_PWD=$(cat /etc/secret-volume/password)
echo "DB username is: $DB_UNAME"
echo "DB password is: $DB_PWD"

set -x
mysql -h $DB_HOSTNAME -u $DB_UNAME --password=$DB_PWD test_app
