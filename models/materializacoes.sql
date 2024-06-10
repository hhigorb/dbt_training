-- Por padrão, se eu não adicionar nenhuma configuração, a tabela é criada como uma View no banco de dados.

/* Materialização do tipo table (cria uma tabela no banco de dados. Se precisar de novos registros,
esse modo de materialização não irá traze-los. Utilize o modo incremental para isso).
*/
{{ config(
    materialized="table"
) }}


-- Materialização do tipo view (cria uma view no banco de dados).
{{ config(
    materialized="view"
) }}


/* Materialização do tipo ephemeral (A materialização do tipo ephemeral não cria uma tabela ou view no 
banco de dados. Em vez disso, ela cria uma subconsulta que é incorporada no momento da execução. Isso 
significa que os dados não são materializados fisicamente em nenhuma tabela ou view no banco de dados. 
A materialização ephemeral é útil para criar transformações intermediárias ou subconsultas que são 
reutilizadas em outras consultas, mas não precisam ser armazenadas fisicamente no banco de dados).
*/
{{ config(
    materialized="ephemeral"
) }}


/* Materialização do tipo incremental (A materialização do tipo incremental cria uma tabela no banco de 
dados que é atualizada de maneira incremental. Isso significa que, em vez de recriar a tabela inteira em 
cada execução, apenas novos dados ou dados atualizados são adicionados à tabela existente. A configuração 
unique_key é usada para identificar registros únicos e determinar quais dados precisam ser atualizados ou inseridos.
Se for a primeira execução no modo incremental, será executado um full.
*/
{{ config(
    materialized="table",
    unique_key="employee_id"
) }}

SELECT 
    * 
FROM
    {{source('redshift_northwind', 'categories')}}