#!/bin/bash
#
# sqoop_import.sh

SCRIPT_LOC=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT_LOC")

source $BASEDIR/mysqlrc
source $BASEDIR/datastagerc

#Create Hive database
echo "Creating Hive Stage DB $HIVE_STG_DB"
hive -e "CREATE DATABASE IF NOT EXISTS $HIVE_STG_DB"


CONN_STR="jdbc:mysql://$MYSQL_HOST/$MYSQL_DB"

sqoop import-all-tables \
--connect $CONN_STR \
--username $MYSQL_USER \
--password $MYSQL_PASS \
--hive-import \
--hive-database $HIVE_STG_DB \
--m 1