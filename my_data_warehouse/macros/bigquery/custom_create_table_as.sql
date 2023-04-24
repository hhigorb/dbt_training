# https://github.com/dbt-labs/dbt-bigquery/issues/16

{# Note that this is implemented in the partition_by object in recent dbt-bigquery #}
{% macro _render_wrapped(partition_by, alias=none) -%}
  {%- if partition_by.data_type == 'int64' -%}
    {{ partition_by.render(alias) }}
  {%- else -%}
    {{ partition_by.data_type }}({{ partition_by.render(alias) }})
  {%- endif -%}
{%- endmacro %}

{% macro bigquery__get_merge_sql(target, source, unique_key, dest_columns, predicates=none) %}
  {% if config.get('match_strategy', 'exact') == 'exact' %}
    {# Standard merge strategy #}
    {{ default__get_merge_sql(target, source, unique_key, dest_columns, predicates) }}
  {% else %}
    {# Use predicates merge strategy #}
    {%- set tmp_relation = make_temp_relation(this) %}
    {%- set raw_partition_by = config.get('partition_by', none) -%}
    {%- set raw_cluster_by = config.get('cluster_by', none) -%}
    {%- set partition_by = adapter.parse_partition_by(raw_partition_by) -%}
    {%- set tmp_relation_exists = tmp_relation.render() in source -%}
    {%- set predicates = [] if predicates is none else predicates -%}

    declare _dbt_min_partition_value {{ partition_by.data_type }};
    declare _dbt_max_partition_value {{ partition_by.data_type }};

    {# have we already created the temp table to check for schema changes? #}
    {% if not tmp_relation_exists %}
      {{ declare_dbt_max_partition(this, partition_by, sql) }}

     -- 1. create a temp table with model data
      {# TODO support ingestion time partitioning but IDK how to call BQ adapter bq_create_table_as #}
      {# bq_create_table_as(partition_by.time_ingestion_partitioning, True, tmp_relation, sql, 'sql') S#}
      {{ bigquery__create_table_as(True, tmp_relation, sql) }}

      {# Disable the sql header, as if there was one it was output to make the temp table; DOES NOT WORK. #}
      {% call set_sql_header(config) %}
        -- header already rendered
      {% endcall %}

      {%- set source -%}
        (
        select
        {% if partition_by.time_ingestion_partitioning -%}
        _PARTITIONTIME,
        {%- endif -%}
        * from {{ tmp_relation }}
        )
      {% endset %}

    {% else %}
      -- 1. temp table already exists, we used it to check for schema changes
    {% endif %}

    -- 2. define partition ranges to update
    set (_dbt_min_partition_value, _dbt_max_partition_value) = (
        select as struct
            min({{ _render_wrapped(partition_by) }}),
            max({{ _render_wrapped(partition_by) }})
        from {{ tmp_relation }}
    );

    -- 3. run the merge statement
    {% set predicate -%}
      {{ _render_wrapped(partition_by, 'DBT_INTERNAL_DEST') }}
        between _dbt_min_partition_value and _dbt_max_partition_value
    {%- endset %}
    {% do predicates.append(predicate) %}
    {{ default__get_merge_sql(target, source, unique_key, dest_columns, predicates) }};

    -- 4. clean up the temp table
    drop table if exists {{ tmp_relation }};
  {% endif %}

{% endmacro %}