-- сумма подтверждённых покупок в витрине должна совпадать с суммой, 
-- посчитанной прямо по source('shop', 'orders') и source('shop', 'payments')
with source_confirmed as (
    select
        o.order_id,
        o.total_amount as order_amount
    from {{ source('shop', 'orders') }} o
    where o.status = 'paid'
      and o.order_id in (
          select order_id
          from {{ source('shop', 'payments') }}
          where payment_status = 'success' and amount > 0
      )
),
marts_confirmed as (
    select order_id, order_amount
    from {{ ref('fct_orders') }}
    where is_confirmed = true
)
select
    coalesce(s.order_id, m.order_id) as order_id,
    s.order_amount as source_amount,
    m.order_amount as marts_amount,
    coalesce(s.order_amount, 0) - coalesce(m.order_amount, 0) as diff
from source_confirmed s
full outer join marts_confirmed m on m.order_id = s.order_id
where s.order_id is null or m.order_id is null
   or abs(s.order_amount - m.order_amount) > 0.01