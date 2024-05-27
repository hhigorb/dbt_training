{{
  config(
    materialized='incremental',
    cluster_by=None,
    unique_key='id',
    tags=['batch']
  )
}}

SELECT 
  _id AS id,
  tenantId AS id_inquilino,
  userId AS id_usuario,
  createdAt AS dt_criacao,
  updatedAt AS dt_alteracao,
  favoriteFruit AS ds_fruta_favorita,
  isFraud AS is_fraude,
  REPLACE(JSON_EXTRACT(document, '$.documentType'), '"', '') AS tp_documento,
  REPLACE(JSON_EXTRACT(document, '$.documentUF'), '"', '') AS sg_uf
FROM 
  {{ ref('my_data_warehouse', 'transactions') }}
{%if is_incremental() %}
    WHERE createdAt >= (SELECT MAX(dt_criacao) FROM {{ this }})
    OR updatedAt >= (SELECT MAX(dt_alteracao) FROM {{ this }})
{% endif %}