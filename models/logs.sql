{{ config(
    materialized="table"
) }}

SELECT 
    *
FROM 
    {{target.schema}}_meta.dbt_audit_log