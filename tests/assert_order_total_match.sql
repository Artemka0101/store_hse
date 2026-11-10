-- Сумма заказа в fct_orders должна равняться сумме line_amount его позиций (записанных в fct_order_items)
select
    o.order_id,
    o.order_amount,
    sum(i.line_amount) as items_total,
    o.order_amount - sum(i.line_amount) as diff
from {{ ref('fct_orders') }} o
join {{ ref('fct_order_items') }} i on i.order_id = o.order_id
group by o.order_id, o.order_amount
having abs(o.order_amount - sum(i.line_amount)) > 0.01