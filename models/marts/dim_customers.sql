{{ config(
    distributed_by='customer_id',
    orientation='column'
) }}

-- витрина клиентов: 1 строка - 1 клиент
with customers as (
    select * from {{ ref('stg_shop__customers') }}
),

confirmed_orders as (
    select * from {{ ref('fct_orders') }}
    where is_confirmed = true 
),

-- собираем данные по заказам для каждого клиента
customer_stats as (
    select
        customer_id,
        count(*) as confirmed_orders_count,
        sum(order_amount) as confirmed_revenue,
        min(order_id) as first_confirmed_order_id, 
        min(ordered_at) as first_confirmed_at
    from confirmed_orders
    group by customer_id
)

select
    c.customer_id,
    c.registration_date,
    cs.confirmed_orders_count,
    cs.confirmed_revenue,
    cs.first_confirmed_order_id,
    cs.first_confirmed_at,
    case when cs.customer_id is not null then true else false end as is_buyer
from customers c
left join customer_stats cs on cs.customer_id = c.customer_id