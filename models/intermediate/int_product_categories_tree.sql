{{ config(materialized='view') }}

-- разворачиваем 3 уровня иерархии категорий
with categories as (
    select * from {{ source('shop', 'product_categories') }}
),

-- корневые категории
level_1 as (
    select 
        category_id as l1_id, 
        category_name as l1_name
    from categories
    where parent_category_id is null
),

-- подкатегории
level_2 as (
    select
        c.category_id as l2_id,
        c.category_name as l2_name,
        l1.l1_id,
        l1.l1_name
    from categories c
    join level_1 l1 on c.parent_category_id = l1.l1_id
),

-- конкретные категории товаров
level_3 as (
    select
        c.category_id as l3_id,
        c.category_name as l3_name,
        l2.l2_id,
        l2.l2_name,
        l2.l1_id,
        l2.l1_name
    from categories c
    join level_2 l2 on c.parent_category_id = l2.l2_id
)

select * from level_3