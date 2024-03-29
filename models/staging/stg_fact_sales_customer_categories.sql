WITH fact_sales_customer_category__source AS(
  SELECT *
  FROM `vit-lam-data.wide_world_importers.sales__customer_categories`
)

, fact_sales_customer_category__rename_column AS(
  SELECT
    customer_category_id AS customer_category_key
    , customer_category_name
  FROM fact_sales_customer_category__source
)

, fact_sales_customer_category__cast_type AS(
  SELECT
    CAST(customer_category_key AS INTEGER) AS customer_category_key
    , CAST(customer_category_name AS STRING) AS customer_category_name
  FROM fact_sales_customer_category__rename_column
) 

SELECT 
  customer_category_key
  , customer_category_name
FROM fact_sales_customer_category__cast_type