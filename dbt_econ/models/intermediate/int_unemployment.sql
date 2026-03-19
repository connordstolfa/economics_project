{{
    config(materialized='table')
}}

with unemp_base as (
    select *
    from {{ ref('stg_fred_date_based_data')}}
    where
        indicator_name = 'unemployment_rate'
)

select
    spine.date_month as date
    , ub.indicator_name
    -- Divide by 100 for consistency as FRED produces a full percent (ie 4.4).
    , ub.value / 100 as unemployment_rate
from {{ ref('int_date_spine_month') }} as spine
left join unemp_base as ub
    on spine.date_month = ub.date
