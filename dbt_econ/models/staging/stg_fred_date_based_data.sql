{{
    config(materialized='table')
}}

-- Jinja will loop through each raw FRED table.
-- List of indicators. Each indicator is stored in a dict with its name and table name.


{% set indicators = var('fred_indicators') %}

with unified_data as (
    {% for ind in indicators %}
        select
            '{{ ind.table_name }}' as indicator_name,
            '{{ ind.series_id }}' as fred_series_id, -- Extra metadata!
            date,
            value
        from {{ source('fred_raw', ind.table_name) }}
    {% if not loop.last %} union all {% endif %}
    {% endfor %}
)

select *
from unified_data
