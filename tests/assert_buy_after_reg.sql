-- первая покупка клиента не должна быть раньше регистрации
select
    customer_id,
    registration_date,
    first_confirmed_at
from {{ ref('dim_customers') }}
where is_buyer = true
  and first_confirmed_at::date < registration_date