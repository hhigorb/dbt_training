{{
  config(
    materialized='table',
    cluster_by=None,
    unique_key=None,
    tags=['batch']
  )
}}

SELECT 
  INITCAP(string_field_0) AS nm_estado
FROM 
  {{ source('higor_workspace', 'estados') }}