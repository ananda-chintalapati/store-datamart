#!/bin/bash
#hive_datamart.sh

SCRIPT_LOC=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT_LOC")

source $BASEDIR/datastagerc

#Create Hive database
echo "Creating Hive Target DB $HIVE_TRG_DB"
hive -e "CREATE DATABASE IF NOT EXISTS $HIVE_TRG_DB"

echo "Creating HIVE datamart tables"
hive -e "set hivevar:HIVE_TRG_DB=$HIVE_TRG_DB;"
hive -hiveconf HIVE_TRG_DB=$HIVE_TRG_DB -f $BASEDIR/hive_trg_table.sql
