{{ config(
    materialized="table"
) }}

WITH markup AS (
    SELECT 
        *,
        FIRST_VALUE(customer_id) OVER (
        PARTITION BY company_name, contact_name 
        ORDER BY company_name
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS result
    FROM 
        {{source('redshift_northwind', 'customers')}}
),

deduplication AS (
    SELECT 
        DISTINCT result
    FROM 
        markup
),

final AS (
    SELECT 
        *
    FROM 
        {{source('redshift_northwind', 'customers')}}
    WHERE 
        customer_id IN (
            SELECT 
                result 
            FROM 
                deduplication
            )
)
  

SELECT 
    *
FROM 
    final
