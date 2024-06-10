WITH checa_duplicados AS (
    SELECT 
        company_name,
        contact_name,
        COUNT(*)
    FROM 
        {{ref("customers")}}
    GROUP BY 
        1,
        2
    HAVING COUNT(*) > 1
)

SELECT 
    *
FROM
    checa_duplicados