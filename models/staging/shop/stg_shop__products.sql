{{ config(materialized='view') }}

-- staging для продуктов
-- каждый товар в отдельной строке
with source as (
    select * from {{ source('shop', 'products') }}
)

select
    product_id,
    product_name,
    brand,
    category as category_name 
from source