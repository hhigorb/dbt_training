{{ config(
    materialized="table"
) }}

SELECT 
    order_details.order_id,
    order_details.product_id,
    order_details.unit_price,
    order_details.quantity,
    products.product_name,
    products.supplier_id,
    products.category_id,
    order_details.unit_price * order_details.quantity AS total,
    (products.unit_price * order_details.quantity) - total AS discount
FROM 
    {{source('redshift_northwind', 'order_details')}} order_details
LEFT JOIN 
    {{source('redshift_northwind', 'products')}} products
ON 
    products.product_id = order_details.product_id