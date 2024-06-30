/*
Macros são trechos de código que podem ser reutilizados várias vezes - eles são como "funções" em
outras linguagens de programação e são extremamente úteis se você estiver repetindo o mesmo código 
em vários modelos. Os macros são definidos em arquivos .sql, geralmente no diretório de macros.

É possível criar quantas macros forem necessárias em um único arquivo .sql
Você chama as macros pelo nome, não pelo arquivo em si. É como funções em linguagens de programação.

Documentação:
https://docs.getdbt.com/docs/build/jinja-macros
https://docs.getdbt.com/guides/using-jinja?step=1
*/


{% macro multiplica_valor_unitario(coluna, fator) %}
    {{ coluna }} * {{ fator }}
{% endmacro %}
