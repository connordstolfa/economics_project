{{
    config(materialized='table')
}}

-- Jinja will loop through each raw FRED table.
-- List of indicators. Each indicator is stored in a dict with its name and table name.

{% set indicators = [
    {'name': 'unemployment', 'table': 'unemployment_rate'},
    {'name': 'cpi', 'table': 'consumer_price_index'},
    {'name': 'core_cpi', 'table': 'core_consumer_price_index'},
    {'name': 'pce', 'table': 'personal_consumption_expenditures_index'},
    {'name': 'real_gdp', 'table': 'real_gdp'},
    {'name': 'real_gdp_per_capita', 'table': 'real_gdp_per_capita'},
    {'name': 'real_income_per_capita', 'table': 'real_income_per_capita'},
    {'name': 'real_median_household_income', 'table': 'real_median_household_income'}
] %}

with unified_data as (
    -- Now loop through the tables.
    {% for ind in indicators %}
        select
            '{{ ind.name }}' as indicator_name,
            *
        from {{ source('fred_raw', ind.table) }}
    {% if not loop.last %}
        union all
    {% endif %}
    {% endfor %}
)

select *
from unified_data
