{{ config(
    distributed_by='date_id',
    orientation='column'
) }}

-- генерируем даты 
with date_gen as (
    select generate_series('2024-01-01'::date, '2026-12-31'::date, interval '1 day')::date as date_day
)

select
    date_day as date_id,
    date_day,
    -- достаём компоненты даты
    extract(year from date_day)::int as year,
    extract(quarter from date_day)::int as quarter,
    extract(month from date_day)::int as month,
    extract(dow from date_day)::int as day_of_week,
    -- чекаем выходной день
    case 
        when extract(dow from date_day) in (0, 6) then true 
        else false 
    end as is_weekend
from date_gen