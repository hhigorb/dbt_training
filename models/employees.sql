{{ config(
    materialized="table"
) }}

WITH calc_employees AS (
    SELECT
        DATEDIFF(YEAR, birth_date, GETDATE()) AS age,
        DATEDIFF(YEAR, hire_date, GETDATE()) AS time_at_company,
        first_name || ' ' || last_name AS full_name,
        *
    FROM 
        {{source('redshift_northwind', 'employees')}}
)

SELECT 
    *
FROM 
    calc_employees
