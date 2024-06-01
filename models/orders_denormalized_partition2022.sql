{{ config(
    materialized="table"
) }}

SELECT 
    *
FROM 
    {{ref('orders_denormalized')}}
WHERE 
    EXTRACT(YEAR FROM order_date) = 2022