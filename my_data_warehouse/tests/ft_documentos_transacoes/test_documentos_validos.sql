-- Normalmente se testa um período com dados chumbados do passado (Ex: ano de 2020 a 2022). Alguma coluna com valores monetários, quantidades, etc.
-- Ou também alguma transação específica.

WITH validacao_documentos AS (
  SELECT 
    COUNT(*) AS qtd_documentos_validos
  FROM
     `cobalt-nomad-322417.higor_workspace.ft_documentos_transacoes`
  WHERE
    is_fraude IS FALSE 
)

SELECT 
  qtd_documentos_validos
FROM 
  validacao_documentos
WHERE 
  qtd_documentos_validos != 4958
