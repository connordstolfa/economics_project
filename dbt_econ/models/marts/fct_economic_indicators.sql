{{
    config(materialized='view')
}}

{% set indicators = var('fred_indicators') %}

with spine as (
    select *
    from {{ ref('int_date_spine_month') }}
),

{% for indicator in indicators %}
    {{ indicator.table_name }}_cte as (
        select 
            date
            , value
        from {{ ref('stg_fred_date_based_data') }}
        where
            indicator_name = '{{ indicator.table_name }}'
    ) {{ "," if not loop.last }}
{% endfor %}

select
    spine.date_month as date
    {% for indicator in indicators %}
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value({{ indicator.table_name }}_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as {{ indicator.table_name }}_value
    {% endfor %}
from spine
{% for indicator in indicators %}
left join {{ indicator.table_name }}_cte 
    on spine.date_month = {{ indicator.table_name }}_cte.date
{% endfor %}
where
    spine.date_month <= today()
order by date_month desc