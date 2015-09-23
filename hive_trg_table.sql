DROP TABLE IF EXISTS ${hiveconf:HIVE_TRG_DB}.product_dim;
DROP TABLE IF EXISTS ${hiveconf:HIVE_TRG_DB}.store_dim;
DROP TABLE IF EXISTS ${hiveconf:HIVE_TRG_DB}.time_dim;
DROP TABLE IF EXISTS ${hiveconf:HIVE_TRG_DB}.sales_fact;



CREATE TABLE IF NOT EXISTS ${hiveconf:HIVE_TRG_DB}.product_dim ( 
		 product_id string,
		 dept_id int,
		 dept_nm string,
		 vendor_id int,
		 vendor_nm string,
		 style_id int,
		 style_nm string,
		 color string,
		 size string)

		 ROW FORMAT DELIMITED
		 FIELDS TERMINATED BY '\t'
		 LINES TERMINATED BY '\n'
		 STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS ${hiveconf:HIVE_TRG_DB}.store_dim ( 
		 store_id int,
		 store_nm string,
		 address string,
		 city string,
		 state string,
		 type string)

		 ROW FORMAT DELIMITED
		 FIELDS TERMINATED BY '\t'
		 LINES TERMINATED BY '\n'
		 STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS ${hiveconf:HIVE_TRG_DB}.time_dim ( 
		trans_date string,
		trans_week string,
		trans_month string,
		trans_year string)

		ROW FORMAT DELIMITED
		FIELDS TERMINATED BY '\t' 
		LINES TERMINATED BY '\n'
		STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS ${hiveconf:HIVE_TRG_DB}.sales_fact ( 
		 product_id string,
		 trans_date string,
		 store_id int,
		 unit_price double,
		 sales_units double,
		 sales_dolrs double)

		 ROW FORMAT DELIMITED
		 FIELDS TERMINATED BY '\t'
		 LINES TERMINATED BY '\n'
		 STORED AS TEXTFILE;
