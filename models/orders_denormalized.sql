{{ config(
    materialized="table"
) }}

WITH denormalization AS (
    SELECT 
        categories.category_name,
        suppliers.company_name AS suppliers,
        products.product_name,
        products.unit_price,
        products.product_id
    FROM 
        {{source('redshift_northwind', 'products')}} products
    LEFT JOIN
        {{source('redshift_northwind', 'suppliers')}} suppliers
    ON
        products.supplier_id = suppliers.supplier_id
    LEFT JOIN
        {{source('redshift_northwind', 'categories')}} categories
    ON 
        products.category_id = categories.category_id
),

order_details AS (
    SELECT 
        denormalization.*,
        order_details.order_id,
        order_details.quantity,
        order_details.discount
    FROM 
        {{ref('order_details')}} order_details 
    LEFT JOIN 
        denormalization
    ON 
        order_details.product_id = denormalization.product_id
),

orders AS (
    SELECT 
        orders.order_date,
        orders.order_id,
        customers.company_name AS customer,
        employees.full_name AS employee,
        employees.age,
        employees.time_at_company
    FROM 
         {{source('redshift_northwind', 'orders')}} orders
    LEFT JOIN
         {{ref('customers')}} customers
    ON 
        orders.customer_id = customers.customer_id
    LEFT JOIN
         {{ref('employees')}} employees 
    ON 
        orders.employee_id = employees.employee_id
    LEFT JOIN
         {{source('redshift_northwind', 'shippers')}} shippers
    ON 
        orders.ship_via = shippers.shipper_id
),

final AS (
    SELECT 
        order_details.*,
        orders.order_date,
        orders.customer,
        orders.employee,
        orders.age,
        orders.time_at_company
    FROM
        order_details order_details
    INNER JOIN 
        orders orders
    ON 
        order_details.order_id = orders.order_id
)

SELECT 
    *
FROM 
    final