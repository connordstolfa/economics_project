{{
    config(materialized='table')
}}

-- Looping through different inflation indicators with Jina, rather than a massive join.
-- Dictionary structure is table_name: intended_alias.
{% 
    set inflation_measures = [
        'consumer_price_index',
        'core_consumer_price_index',
        'personal_consumption_expenditures_index'
    ]
%}

with base as (
    select
        *
        , (
            (value - lag(value, 12) over (partition by indicator_name order by date)) 
            / 
            lag(value, 12) over (partition by indicator_name order by date)
        ) as inflation_rate
    from {{ ref('stg_fred_date_based_data') }}
    where
        indicator_name in ('{{ inflation_measures | join("', '") }}')
)

, {% for measure in inflation_measures %}
    {{ measure }}_cte as (
        select
            date
            , value as {{ measure }}_value
            , inflation_rate as {{ measure }}_inflation_rate
        from base
        where
            indicator_name = '{{ measure }}'
    )
    {{ "," if not loop.last }}
{% endfor %}

select
    spine.date_month as date
    {% for measure in inflation_measures %}
        , {{ measure }}_value
        , {{ measure }}_inflation_rate
    {% endfor %}
from {{ ref('int_date_spine_month') }} as spine
{% for measure in inflation_measures %}
    left join {{ measure }}_cte
        on spine.date_month::date = {{ measure }}_cte.date::date
{% endfor %}
