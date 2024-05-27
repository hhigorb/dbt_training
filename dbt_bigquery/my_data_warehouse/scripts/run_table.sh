#!/bin/sh

for i in "$@"
do
case $i in
    -table-name=*)
    TABLE_NAME="${i#*=}"
    shift # past argument=value
    ;;
    -label=*)
    LABEL="${i#*=}"
    shift # past argument=value
    ;;
    *)
    # unknown option
    ;;
esac
done

if [ "$DBT_PROD_CONFIG" = "prod" ]
then
    echo "Rodando em produção"
    dbt deps --profiles-dir .
    dbt run --models $TABLE_NAME --profiles-dir .
else
    echo "Rodando em dev"
    dbt deps
    dbt run --models $TABLE_NAME 
fi