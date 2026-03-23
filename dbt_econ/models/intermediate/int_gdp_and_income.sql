{{
    config(materialized='table')
}}

{% 
    set indicators = [
        'real_gdp',
        'real_gdp_per_capita',
        'real_income_per_capita',
        'real_median_household_income'
    ]
%}

with base as (
    select
        date
        , indicator_name
        -- Real GDP is show in billions of dollars. 
        -- Making it uniform with the other values below.
        , if(
                indicator_name = 'real_gdp',
                value * 1000000000,
                value
            ) as value
    from {{ ref('stg_fred_date_based_data') }}
    where
        indicator_name in ('{{ indicators | join("', '") }}')
)

, {% for indicator in indicators %}
    {{ indicator }}_cte as (
        select
            date
            , value as {{ indicator }}_value
        from base
        where
            indicator_name = '{{ indicator }}'
    )
    {{ "," if not loop.last }}
{% endfor %}

select
    spine.date_month as date
    {% for indicator in indicators %}
        , last_value({{ indicator }}_value ignore nulls) over (
            order by date_month 
            rows between unbounded preceding and current row
        ) as {{ indicator }}_value
    {% endfor %}
from {{ ref('int_date_spine_month') }} as spine
{% for indicator in indicators %}
    left join {{ indicator }}_cte
        on spine.date_month = {{ indicator }}_cte.date
{% endfor %}
order by
    spine.date_month desc
