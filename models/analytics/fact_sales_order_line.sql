WITH fact_sales_order_line__source AS (
  SELECT *
  FROM `vit-lam-data.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS(
  SELECT
    stock_item_id  AS product_key
    , order_id as sales_order_key
    , order_line_id  AS sales_order_line_key
    , quantity  AS quantity
    , unit_price  AS unit_price
  FROM fact_sales_order_line__source
)

,fact_sales_order_line__cast_type AS(
  SELECT
    CAST(product_key AS INTEGER) AS product_key
    , CAST(sales_order_key AS INTEGER) AS sales_order_key
    , CAST(sales_order_line_key AS INTEGER) AS sales_order_line_key
    , CAST(quantity AS INTEGER) AS quantity
    , CAST(unit_price AS NUMERIC) AS unit_price
  FROM fact_sales_order_line__rename_column
)

, fact_sales_order_line__calculate_measure AS(
SELECT
  product_key
  , sales_order_key
  , sales_order_line_key
  , quantity
  , unit_price
  , quantity*unit_price AS gross_amount
FROM fact_sales_order_line__cast_type 
)

  SELECT
  fact_line.sales_order_line_key
  , fact_line.product_key
  , fact_line.sales_order_key
  , COALESCE(fact_header.customer_key, -1) AS customer_key
  , COALESCE(fact_header.picked_by_person_key, -1) AS picked_by_person_key
  , fact_line.quantity
  , fact_line.unit_price
  , fact_line.quantity*fact_line.unit_price AS gross_amount
  , fact_header.order_date AS order_date
FROM fact_sales_order_line__calculate_measure AS fact_line
LEFT JOIN {{ref('stg_fact_sales_order')}} AS fact_header 
  ON fact_line.sales_order_key = fact_header.sales_order_key