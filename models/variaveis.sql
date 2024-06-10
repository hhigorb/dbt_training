/*
É possível definir variáveis dentro do arquivo dbt_project ou chamar diretamente via linha de comando.

dbt_project.yml:

vars:
  # The `start_date` variable will be accessible in all resources
  start_date: '2016-06-01'

  # The `platforms` variable is only accessible to resources in the my_dbt_project project
  my_dbt_project:
    platforms: ['web', 'mobile']

  # The `app_ids` variable is only accessible to resources in the snowplow package
  snowplow:
    app_ids: ['marketing', 'app', 'landing-page']

Linha de comando:

dbt run --select variaveis --vars 'category: Condiments'

*/

{{ config(
    materialized="table"
) }}

SELECT 
    *
FROM 
    {{ ref('orders_denormalized') }}
WHERE 
    category_name = '{{var('category')}}'