{{ config(
    distributed_by='order_id',
    orientation='column'
) }}

-- 1 строка — 1 товар в заказе.
-- cоединяем позиции с заказами, чтобы подтянуть статусы (ну и исключить тестовые), 
-- и ещё с товарами, чтобы подтянуть категории

with order_items as (
    select * from {{ ref('stg_shop__order_items') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
),

products as (
    select * from {{ ref('dim_products') }}
)

select
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    oi.line_amount,
    -- данные заказа из fct_orders
    o.order_date,
    o.is_confirmed,
    o.customer_id
from order_items oi
inner join orders o on o.order_id = oi.order_id
left join products p on p.product_id = oi.product_id