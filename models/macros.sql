{{ config(
    materialized="table"
) }}

SELECT 
    order_id,
    product_id,
    product_name,
    unit_price,
    {{ multiplica_valor_unitario('unit_price', 10) }} AS valor_unitario_fator_10
FROM 
    {{ ref('orders_denormalized') }}