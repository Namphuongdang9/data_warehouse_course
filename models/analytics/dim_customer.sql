WITH dim_customer__source AS(
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS(
  SELECT 
    customer_id AS customer_key
    , customer_name AS customer_name
    , customer_category_id AS customer_category_key
    , buying_group_id AS buying_group_key
  FROM dim_customer__source
)

, dim_customer__cast_type AS(
  SELECT 
    CAST(customer_key AS INTEGER) AS customer_key
    , CAST(customer_name AS STRING) AS customer_name
    , CAST(customer_category_key AS INTEGER) AS customer_category_key
    , CAST(buying_group_key AS INTEGER) AS buying_group_key
  FROM dim_customer__rename_column
)

SELECT 
  dim_customer.customer_key
  , dim_customer.customer_name
  , dim_customer.customer_category_key
  , fact_sales_customer_categories.customer_category_name
  , fact_sales_buying_groups.buying_group_key
  , buying_group_name
FROM dim_customer__cast_type AS dim_customer
LEFT JOIN {{ ref('stg_fact_sales_customer_categories') }} AS fact_sales_customer_categories
  ON dim_customer.customer_category_key = fact_sales_customer_categories.customer_category_key
LEFT JOIN {{ ref('stg_fact_sales_buying_groups') }} AS fact_sales_buying_groups
  ON dim_customer.buying_group_key = fact_sales_buying_groups.buying_group_key 

