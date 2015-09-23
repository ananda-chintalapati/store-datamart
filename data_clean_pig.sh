#!/bin/bash
#
#

SCRIPT_LOC=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT_LOC")

source $BASEDIR/datastagerc

#Create Hive database
echo "Creating Hive Target DB $HIVE_TRG_DB"
hive -e "CREATE DATABASE IF NOT EXISTS $HIVE_TRG_DB"

echo "Creating HIVE datamart tables"

hive -hiveconf HIVE_TRG_DB=$HIVE_TRG_DB -f $BASEDIR/hive_trg_table.sql

echo "Triggering PIG script for data staging"
HIVE_DB_PATH=/user/hive/warehouse/$HIVE_STG_DB.db
pig -useHCatalog -f $BASEDIR/data_clean.pig -param HIVE_STG_DB=$HIVE_STG_DB -param UDF_PATH=$BASEDIR -param HIVE_TRG_DB=$HIVE_TRG_DB

