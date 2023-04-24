## dbt

### Resources

* Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
* Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
* Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
* Find [dbt events](https://events.getdbt.com) near you
* Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

### Configurar o dbt na sua máquina

Crie um ambiente virtual Python:

* ```mkvirtualenv dbt --python=/usr/local/opt/python@3.8/bin/python3```

Instale as dependências:

* Instale as dependências encontradas no arquivo requirements.txt

Configure o arquivo profiles.yml localmente:

* Você irá precisar fazer o download chave de conexão com o DW do seu provedor Cloud;
* Procure em sua máquina o arquivo profiles.yml encontrado em .dbt/profiles.yml;
* Exclua todo o conteúdo do profiles.yml e cole a seguinte configuração, adicionando o caminho correto para o keyfile:

```yml
omni_dw:
  outputs:
    dev:
      dataset: dataset_name
      fixed_retries: 1
      keyfile: caminho_para_json/file.json
      location: US
      method: service-account
      priority: interactive
      project: project_name
      threads: 1
      timeout_seconds: 300
      type: bigquery
    prod:
      dataset: dataset_name
      fixed_retries: 1
      keyfile: caminho_para_json/file.json
      location: US
      method: service-account
      priority: interactive
      project: project_name
      threads: 1
      timeout_seconds: 300
      type: bigquery
  target: prod
```

Execute o comando dbt debug para checar se as configurações e conexões estão funcionando corretamente.

### Como executar uma tabela - PARTIAL

dbt run --models nome_da_tabela

### Como executar uma tabela - FULL

dbt run --full-refresh --models nome_da_tabela

### Comandos úteis dbt

* dbt init nome_do_projeto
* dbt init: inicializa um projeto dbt.
* dbt debug: realiza o debug para testar se as conexões estão funcionando corretamente.
* dbt run: roda o projeto.
* dbt test: realiza teste de cada coluna baseado no arquivo schema.
  * --select test_type:singular: Somente testes customizados. Exemplo: dbt test --models nome_da_tabela --select test_type:singular
* dbt run --select tag:my_tag: seleciona uma tag específica para rodar.
* dbt docs generate: gera uma documentação do projeto na pasta target.
* dbt docs serve: sobe o html do modelo DTB em si.
* dbt run/test --models nome_do_modelo: roda um modelo em específico
* dbt run --full-refresh --models nome_do_modelo: roda um modelo full sem precisar deletar a tabela do banco de dados.
* {{
  config(
    materialized='table', alias='nome_da_tabela'
  )
}}: defino o nome da tabela dentro do próprio config

* FROM {{ ref ('nome_tabela') }}: forma de referenciar tabelas