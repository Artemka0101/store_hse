{{ config(
    distributed_by='product_id',
    orientation='column'
) }}

-- витрина товаров: 1 строка - 1 товар
with products as (
    select * from {{ ref('stg_shop__products') }}
),

categories_tree as (
    select * from {{ ref('int_product_categories_tree') }}
)

select distinct
    p.product_id,
    p.product_name,
    p.brand,
    -- категория товара - хранится в products
    p.category_name,
    -- родительская категория (приходится чекать, потому что она зависит от уровня товара)
    case
        when p.category_name = ct.l3_name then ct.l2_name  -- если l3
        when p.category_name = ct.l2_name then ct.l1_name  -- если l2
        when p.category_name = ct.l1_name then null         -- если l1 (родителя нет)
    end as parent_category_name,
    ct.l1_name as root_category_name
from products p
left join categories_tree ct 
    on p.category_name = ct.l1_name 
    or p.category_name = ct.l2_name 
    or p.category_name = ct.l3_name