/*
Para utilizar Jinja para lidar com campos de data em uma materialização incremental,
você pode aproveitar as funções de manipulação de data disponíveis no Jinja. Por exemplo, 
se você deseja adicionar apenas os dados novos ou atualizados desde a última execução, pode 
usar um campo de data para identificar os registros incrementais. Aqui está um exemplo de como fazer isso:

Defina a configuração de materialização incremental.
Utilize Jinja para definir a lógica de atualização incremental com base em um campo de data.
Supondo que você tenha um campo chamado updated_at que rastreia quando os registros foram
atualizados, você pode usar a seguinte abordagem:
*/

-- Materialização do tipo incremental (cria uma tabela no banco de dados que é atualizada de maneira incremental)
{{ config(
    materialized="incremental",
    unique_key="employee_id"
) }}

-- Se for uma execução incremental, adicione a cláusula WHERE para buscar apenas os registros atualizados recentemente
{% if is_incremental() %}
    SELECT 
        * 
    FROM
        {{source('redshift_northwind', 'employees')}}
    WHERE
        hire_date > (SELECT MAX(hire_date) FROM {{ this }})
{% else %}
    -- Se não for uma execução incremental, carregue todos os dados
    SELECT 
        * 
    FROM
        {{source('redshift_northwind', 'employees')}}
{% endif %}

/*
Nesse exemplo:

{{ config(materialized="incremental", unique_key="category_id") }} define a configuração para a materialização incremental, com category_id como chave única.

if is_incremental() verifica se a execução é incremental.

Se for uma execução incremental, o SQL filtra os dados para incluir apenas os registros
com updated_at maiores que a última atualização na tabela atual {{ this }}.

Se não for uma execução incremental, todos os dados são carregados.

Essa abordagem garante que apenas os dados novos ou atualizados desde a última execução sejam processados e adicionados à tabela incrementalmente.
*/