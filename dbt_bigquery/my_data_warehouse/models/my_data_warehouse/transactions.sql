{{
  config(
    materialized='table',
    cluster_by=None,
    unique_key=None,
    tags=['batch']
  )
}}

SELECT 
  *
FROM 
  {{ source('higor_workspace', 'transactions') }}
  