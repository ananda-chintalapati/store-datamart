CREATE DATABASE IF NOT EXISTS store;

USE store;

DROP TABLE IF EXISTS time_dim;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS dept;
DROP TABLE IF EXISTS vendor;
DROP TABLE IF EXISTS style;
DROP TABLE IF EXISTS store;

CREATE TABLE time_dim (
	TRANS_DATE DATE NOT NULL,
	TRAN_WEEK INTEGER NOT NULL,
	TRAN_MONTH INTEGER NOT NULL,
	TRAN_YEAR INTEGER NOT NULL
);

CREATE TABLE sales (
	TRANS_DATE DATETIME NOT NULL,
	STORE_ID INTEGER NOT NULL,
	DEPT_ID INTEGER NOT NULL,
	VENDOR_ID INTEGER NOT NULL,
	STYLE_ID INTEGER NOT NULL,
	COLOR VARCHAR(20),
	SIZE VARCHAR(10),
	UNIT_PRICE DOUBLE NOT NULL,
	SALES_UNITS DOUBLE NOT NULL,
	SALES_DOLRS DOUBLE NOT NULL
);

CREATE TABLE dept (
	DEPT_ID INTEGER NOT NULL,
	DEPT_NM VARCHAR(20) NOT NULL,
	PRIMARY KEY('DEPT_ID')
);

CREATE TABLE vendor (
	VENDOR_ID INTEGER,
	VENDOR_NM VARCHAR(20),
	PRIMARY KEY('VENDOR_ID')
);

CREATE TABLE style (
	STYLE_ID INTEGER,
	STYLE_NM VARCHAR(30),
	PRIMARY KEY('STYLE_ID')
);

CREATE TABLE store (
	STORE_ID INTEGER NOT NULL,
	STORE_NM VARCHAR(30) NOT NULL,
	ADDRESS VARCHAR(250),
	CITY VARCHAR(20) NOT NULL,
	STATE VARCHAR(20) NOT NULL,
	STORE_TYPE VARCHAR(2) NOT NULL
	PRIMARY KEY('STORE_ID')
);

COMMIT;