#!/bin/bash

echo "Connecting to MySQL database..."
set -x
mysql -h 127.0.0.1 test_app
