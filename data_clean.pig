REGISTER datafu.jar;
DEFINE SHA datafu.pig.hash.SHA();
REGISTER $UDF_PATH/store-udf.jar;

-- Load source data from HIVE
str_src_data = LOAD '$HIVE_STG_DB.store' USING org.apache.hive.hcatalog.pig.HCatLoader() AS 
		 (STORE_ID:INT,
		 STORE_NM:CHARARRAY,
		 ADDRESS:CHARARRAY,
		 CITY:CHARARRAY,
		 STATE:CHARARRAY,
		 STORE_TYPE:CHARARRAY);

sale_src_data = LOAD '$HIVE_STG_DB.sales' USING org.apache.hive.hcatalog.pig.HCatLoader() AS 
		 	(TRANS_DATE:CHARARRAY,
			STORE_ID:INT,
			DEPT_ID:INT,
			VENDOR_ID:INT,
			STYLE_ID:INT,
			COLOR:CHARARRAY,
			SIZE:CHARARRAY,
			UNIT_PRICE:DOUBLE,
			SALES_UNITS:DOUBLE,
			SALES_DOLRS:DOUBLE);

dept_src_data = LOAD '$HIVE_STG_DB.dept' USING org.apache.hive.hcatalog.pig.HCatLoader() AS 
			(DEPT_ID:INT,
			DEPT_NM:CHARARRAY);

vndr_src_data = LOAD '$HIVE_STG_DB.vendor' USING org.apache.hive.hcatalog.pig.HCatLoader() AS 
			(VENDOR_ID:INT,
			VENDOR_NM:CHARARRAY);

stl_src_data = LOAD '$HIVE_STG_DB.style' USING org.apache.hive.hcatalog.pig.HCatLoader() AS 
			(STYLE_ID:INT,
			STYLE_NM:CHARARRAY);

-- Data staging

-- Filter sales table for valid sale units
sale_fltr_data = FILTER sale_src_data BY SALES_UNITS > -1;

-- Relation joins
sale_str_jn = JOIN sale_src_data BY STORE_ID, str_src_data BY STORE_ID;
slst_dept_jn = JOIN sale_str_jn BY DEPT_ID, dept_src_data BY DEPT_ID;
slstdp_vndr_jn = JOIN slst_dept_jn BY VENDOR_ID, vndr_src_data BY VENDOR_ID;
all_rel_jn = JOIN slstdp_vndr_jn BY STYLE_ID, stl_src_data BY STYLE_ID;

-- Rank relation for generating surrogate key
all_rel_rank = RANK all_rel_jn;

-- Prepare target data
prd_rank_data = FOREACH all_rel_rank GENERATE SHA((chararray)rank_all_rel_jn) AS product_id, slstdp_vndr_jn::slst_dept_jn::sale_str_jn::sale_src_data::DEPT_ID AS dept_id, slstdp_vndr_jn::slst_dept_jn::dept_src_data::DEPT_NM AS dept_nm, slstdp_vndr_jn::vndr_src_data::VENDOR_ID AS vendor_id, slstdp_vndr_jn::vndr_src_data::VENDOR_NM AS vendor_nm, stl_src_data::STYLE_ID AS style_id, stl_src_data::STYLE_NM AS style_nm, slstdp_vndr_jn::slst_dept_jn::sale_str_jn::sale_src_data::COLOR AS color, slstdp_vndr_jn::slst_dept_jn::sale_str_jn::sale_src_data::SIZE AS size;

tim_data = FOREACH sale_fltr_data GENERATE TRANS_DATE AS trans_date, com.example.WeekOf(TRANS_DATE) AS trans_week, SUBSTRING(TRANS_DATE, 4, 5) AS trans_month, SUBSTRING(TRANS_DATE, 0, 3) AS trans_year;

str_data = FOREACH str_src_data GENERATE STORE_ID AS store_id, STORE_NM AS store_nm, ADDRESS AS address, CITY AS city, STATE AS state, STORE_TYPE AS type;

prd_rank_sale_jn = JOIN prd_rank_data BY (dept_id, vendor_id, style_id), sale_fltr_data BY (DEPT_ID, VENDOR_ID, STYLE_ID);

sale_fact_data = FOREACH prd_rank_sale_jn GENERATE prd_rank_data::product_id AS product_id, sale_fltr_data::TRANS_DATE AS trans_date, sale_fltr_data::STORE_ID AS store_id, sale_fltr_data::UNIT_PRICE AS unit_price, sale_fltr_data::SALES_UNITS AS sales_units, sale_fltr_data::SALES_DOLRS AS sales_dolrs;


-- Load data to HIVE DB
STORE prd_rank_data INTO '$HIVE_TRG_DB.product_dim' USING org.apache.hive.hcatalog.pig.HCatStorer();
STORE tim_data INTO '$HIVE_TRG_DB.time_dim' USING org.apache.hive.hcatalog.pig.HCatStorer();
STORE str_data INTO '$HIVE_TRG_DB.store_dim' USING org.apache.hive.hcatalog.pig.HCatStorer();
STORE sale_fact_data INTO '$HIVE_TRG_DB.sales_fact' USING org.apache.hive.hcatalog.pig.HCatStorer();
