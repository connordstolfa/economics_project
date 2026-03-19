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
            date,
            value
        from {{ ref('stg_fred_date_based_data') }}
        where
            indicator_name = '{{ indicator.table_name }}'
    ) {{ "," if not loop.last }}
{% endfor %}

select
    spine.date_month as date
    {% for indicator in indicators %}
        , {{ indicator.table_name }}_cte.value as {{ indicator.table_name }}_value
    {% endfor %}
from spine
{% for indicator in indicators %}
left join {{ indicator.table_name }}_cte 
    on spine.date_month = {{ indicator.table_name }}_cte.date
{% endfor %}
