{{
    config(severity='warn')
}}

select
    order_id,
    order_amount,
    paid_amount,
    paid_amount - order_amount as overpaid_diff
from {{ ref('fct_orders') }}
where is_confirmed = true
  and paid_amount > order_amount + 0.01