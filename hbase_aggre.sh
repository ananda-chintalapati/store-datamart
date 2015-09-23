#!/bin/bash

echo "Creating HBase tables"

STORE_AGGR="CREATE TABLE store_aggr (key int, store_id int, total_sale_units double, total_sale_amount double) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
			WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,store_id:store_id,total_sale_units:total_sale_units,total_sale_amount:total_sale_amount");
			INSERT OVERWRITE TABLE store_aggr SELECT store_id, SUM(sales_units) AS total_sale_units, SUM(sales_dolrs) AS total_sale_amount FROM sales_fact GROUP BY store_id;"

VENDOR_AGGR="CREATE TABLE vendor_aggr (key int, vendor_id int, vendor_nm string, total_sale_units double, total_sale_amount double) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
			WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,vendor_id:vendor_id,vendor_nm:vendor_nm,total_sale_units:total_sale_units,total_sale_amount:total_sale_amount");			
			INSERT OVERWRITE TABLE vendor_aggr SELECT p.vendor_id AS vendor_id, p.vendor_nm AS vendor_nm, SUM(s.sales_units) AS total_sale_units, SUM(s.sales_dolrs) AS total_sale_amout FROM product_dim p, sales_fact s WHERE p.product_id = s.product_id GROUP BY p.vendor_id, p.vendor_nm;"

MONTH_AGGR="CREATE TABLE month_aggr (key int, month int, total_sale_units double, total_sale_amount double) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
			WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,month:month,total_sale_units:total_sale_units,total_sale_amount:total_sale_amount");			
			INSERT OVERWRITE TABLE month_aggr SELECT t.trans_month AS month, SUM(s.sales_units) AS total_sale_units, SUM(s.sales_dolrs) AS total_sale_amout FROM time_dim t, sales_fact s WHERE t.trans_date = s.trans_date GROUP BY t.trans_month;"

DEPT_AGGR="CREATE TABLE dept_aggr (key int, dept_id int, dept_nm string, total_sale_units double, total_sale_amount double) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
			WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,dept_id:dept_id,dept_nm:dept_nm,total_sale_units:total_sale_units,total_sale_amount:total_sale_amount");			
			INSERT OVERWRITE TABLE dept_aggr SELECT p.dept_id AS dept_id, p.dept_nm AS dept_nm, SUM(s.sales_units) AS total_sale_units, SUM(s.sales_dolrs) AS total_sale_amout FROM product_dim p, sales_fact s WHERE p.product_id = s.product_id GROUP BY p.dept_id, p.dept_nm;"

echo $STORE_AGGR | hbase shell
echo $VENDOR_AGGR | hbase shell
echo $MONTH_AGGR | hbase shell
echo $DEPT_AGGR | hbase shell

