/*
Criando um usuário e grupo no banco

CREATE GROUP data_analysts;

CREATE USER test WITH PASSWORD '123Abc@456'

ALTER GROUP data_analysts ADD USER test;

Vamos utilizar hooks para cada momento em que essa tabela for executada,
seja concedido permissão (GRANT) de leitura para o grupo de usuários 'data_analysts'.

O {{target.schema}} é uma variável especial que se refere ao esquema para o qual você está concedendo permissões
após a materialização de uma tabela. Essa variável é dinâmica e será preenchida automaticamente com o
esquema alvo definido no seu ambiente DBT, permitindo que você conceda permissões de forma flexível e 
reutilizável, sem precisar modificar manualmente o código para cada esquema.

O valor de {{target.schema}} é definido no arquivo dbt_project.yml. No seu projeto dbt, você pode ter
um arquivo chamado dbt_project.yml que contém várias configurações para seu projeto, incluindo a 
definição do esquema alvo (target.schema).

No dbt_project.yml, você pode definir o target.schema da seguinte maneira:

# dbt_project.yml

...

models:
  my_model:
    schema: my_target_schema

Neste exemplo, my_target_schema é o valor que será atribuído à variável target.schema quando você executar
o código dbt. Isso significa que todas as referências a target.schema em seu código dbt serão substituídas
por my_target_schema durante a execução.

Resumindo, se eu tiver executando no schema dev_higor por exemplo, o {{target.schema}} irá preencher em tempo
de execução 'dev_higor'.
*/

{{ config(
    materialized="table",
    pre_hook=["
        BEGIN; LOCK TABLE {{target.schema}}.hooks;
    "],
    post_hook=["
        COMMIT;
        GRANT USAGE ON SCHEMA {{target.schema}} TO GROUP data_analysts;
        GRANT SELECT ON TABLE {{target.schema}}.hooks TO GROUP data_analysts;
    "]
) }}

SELECT 
    *
FROM 
    {{ ref('orders_denormalized') }}