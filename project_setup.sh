#!/bin/bash
# Shell script for DW project data setup

SCRIPT_LOC=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT_LOC")
INPUT_DATA=$BASEDIR/project_data
MYSQL_SCHEMA=$BASEDIR/store_schema.sql

source $BASEDIR/mysqlrc

echo "Creating database $MYSQL_DB"

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB"

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB < $MYSQL_SCHEMA

# MySQL Load queries

DEPT_Q="LOAD DATA INFILE '$INPUT_DATA/dept.dat' 
		  INTO TABLE dept 
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

SALES_Q="LOAD DATA INFILE '$INPUT_DATA/sales.dat' 
		  INTO TABLE sales 
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

STYLE_Q="LOAD DATA INFILE '$INPUT_DATA/style.dat' 
		  INTO TABLE style 
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

STORE_Q="LOAD DATA INFILE '$INPUT_DATA/store.dat' 
		  INTO TABLE store 
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

TIME_DIM_Q="LOAD DATA INFILE '$INPUT_DATA/time_dim.dat' 
		  INTO TABLE time_dim
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

VENDOR_Q="LOAD DATA INFILE '$INPUT_DATA/vendor.dat' 
		  INTO TABLE vendor 
		  FIELDS TERMINATED BY ',' 
		  LINES TERMINATED BY '\n';"

# Load data to tables

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB << eof 
$DEPT_Q
$SALES_Q
$STYLE_Q
$STORE_Q
$TIME_DIM_Q
$VENDOR_Q
eof