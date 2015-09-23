-- Store level aggregates
SELECT SUM(sales_units), SUM(sales_dolrs), store_id FROM sales_fact GROUP BY store_id;

-- Vendor level aggregates
