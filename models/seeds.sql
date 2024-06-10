/*
Seeds são arquivos que contêm dados estáticos ou pré-definidos que você pode usar para iniciar ou testar
seus modelos de dados no dbt. Eles são úteis para fornecer dados de exemplo ou dados que não mudam
com frequência, facilitando o desenvolvimento e teste do seu projeto de análise de dados.

Basicamente são arquivos csv que estão na pasta 'seeds'. Ao rodar o comando 'dbt seed', você poderá
utilizar o arquivo csv como um modelo em seu banco de dados.
*/

{{ config(
    materialized="table"
) }}

SELECT 
    *
FROM 
    {{ref('shippers_emails')}}