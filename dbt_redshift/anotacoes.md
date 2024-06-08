# dbt

## Como o dbt funciona?

Para qualquer dúvida, sempre consulte a documentação oficial da ferramenta: https://docs.getdbt.com/docs/get-started-dbt

![Como o dbt funciona](images/image1.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image2.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image3.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image4.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image5.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image6.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image7.png 'Como o dbt funciona')

---

O dialeto SQL executado pelo dbt é o dialeto do banco de dados que você está utilizando. Se está no Redshift por exemplo, os comandos SQL, funções, etc, são referentes ao Redshift. O dbt não executa nada, ele apenas envia o SQL compilado para o cluster de banco de dados que você está executando.

![Como o dbt funciona](images/image8.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image9.png 'Como o dbt funciona')

---

![Como o dbt funciona](images/image10.png 'Como o dbt funciona')

---

## Estrutura de pastas de um projeto dbt

![Estrutura de pastas](images/image11.png 'Estrutura de pastas')

https://docs.getdbt.com/docs/build/projects

## Referências (ref) e Sources (source)

**Ref:** Tabela que já está no dbt, é um modelo que já foi criado.

**Sources:** Tabela do banco de dados de origem (tabela raw do DW).

![Ref e Sources](images/image12.png 'Ref e Sources')

---

## Materializações

![Materializações](images/image13.png 'Materializações')

---

![Materializações](images/image14.png 'Materializações')

---

![Materializações](images/image15.png 'Materializações')

---

![Materializações](images/image16.png 'Materializações')

---

![Materializações](images/image17.png 'Materializações')

---

![Materializações](images/image18.png 'Materializações')

---

## Testes no dbt

![Testes](images/image19.png 'Testes')

---

![Testes](images/image20.png 'Testes')

---

## Hooks

Hooks no dbt são comandos SQL ou operações que você pode configurar para serem executados automaticamente antes ou depois de certas ações em seu fluxo de trabalho de dbt. Eles são úteis para realizar tarefas preparatórias ou de limpeza, como configurar variáveis, limpar tabelas temporárias ou registrar informações de auditoria. Existem principalmente dois tipos de hooks:

**Pre-hook:** Executados antes de um modelo ser executado.

**Post-hook:** Executados após a execução de um modelo.

Esses hooks permitem automatizar e personalizar processos adicionais em suas transformações de dados, garantindo que tudo esteja em ordem antes e depois da execução das suas operações principais.

![Hooks](images/image21.png 'Hooks')

---

![Hooks](images/image22.png 'Hooks')

---

## Pacotes (libs) no dbt

No dbt, packages são coleções de modelos, macros e outros recursos que você pode reutilizar em seus projetos de análise de dados. Eles funcionam como bibliotecas ou módulos que facilitam a implementação de funcionalidades comuns sem precisar escrever o código do zero. Você pode baixar e instalar pacotes de uma comunidade de desenvolvedores ou criar seus próprios pacotes para compartilhar entre diferentes projetos.

O arquivo packages.yml é onde você define as dependências do seu projeto dbt. Nele, você especifica os pacotes que seu projeto precisa. O dbt usa esse arquivo para baixar e instalar esses pacotes.

![Libs](images/image23.png 'Libs')

Você pode achar todos os pacotes disponíveis neste link: https://hub.getdbt.com/

---

## Comandos úteis dbt

Todo comando dbt começa com a palavra reservada dbt, seguida pelo comando.

Os principais comandos dbt são:

##### Inicializa um novo projeto dbt. Esse comando cria a estrutura de diretórios e arquivos padrão necessários para começar a usar o dbt.
```terminal
dbt init my_new_project
```

##### Verifica a configuração do dbt e a conectividade com o banco de dados. Esse comando ajuda a garantir que todas as configurações estejam corretas antes de executar outros comandos.
```terminal
dbt debug
```

##### Baixa as dependências listadas no arquivo packages.yml. É utilizado para gerenciar pacotes dbt de terceiros.
```terminal
dbt deps
```

##### Remove todos os artefatos gerados pelo dbt, como diretórios de compilação e logs. É útil para iniciar uma nova execução do zero.
```terminal
dbt clean
```

##### Carrega dados de arquivos CSV na pasta data para o banco de dados. Esses dados podem ser usados como tabelas de referência no seu projeto dbt.
```terminal
dbt seed
```

##### Compila e executa os modelos dbt, criando tabelas e visualizações no banco de dados de acordo com as transformações definidas no projeto.
```terminal
dbt run
```

##### Executa transformações, testes, snapshots e seeds do projeto dbt, preparando e validando os dados no banco de dados (roda os comandos dbt run, test, snapshot e seed).
```terminal
dbt build
```

##### Tira "fotografias" das tabelas de origem para capturar a evolução dos dados ao longo do tempo. É usado para auditoria e rastreamento de mudanças nos dados.
```terminal
dbt snapshot
```

##### Executa testes nos dados para garantir a qualidade e integridade dos mesmos. Os testes são definidos nos arquivos de schema ou scripts SQL na pasta tests e podem verificar valores nulos, unicidade, relações entre tabelas, entre outros.
```terminal
dbt test
```

##### Compila os modelos dbt em arquivos SQL sem executá-los. Esse comando é útil para revisar o SQL gerado antes de executá-lo no banco de dados.
```terminal
dbt compile
```

##### Gera a documentação do projeto dbt, incluindo descrições de modelos, colunas e testes. A documentação é gerada como arquivos HTML que podem ser servidos localmente.
```terminal
dbt docs generate
```

##### Serve a documentação gerada pelo comando dbt docs generate em um servidor web local. Isso permite visualizar e navegar pela documentação do projeto no navegador.
```terminal
dbt docs serve
```

Consulte a documentação oficial para checar todos os comandos do dbt: https://docs.getdbt.com/reference/dbt-commands
