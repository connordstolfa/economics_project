

select 
    -- Cast the generated value to a DATE
    cast(range as date) as date_month
from range(
    '1920-01-01'::date, 
    current_date + interval '1 month', 
    interval '1 month'
)