
  
    
    

    create  table
      "economics"."main"."int_unemployment__dbt_tmp"
  
    as (
      

with unemp_base as (
    select *
    from "economics"."main"."stg_fred_date_based_data"
    where
        indicator_name = 'unemployment_rate'
)

select
    spine.date_month as date
    , ub.indicator_name
    -- Divide by 100 for consistency as FRED produces a full percent (ie 4.4).
    , ub.value / 100 as unemployment_rate
from "economics"."main"."int_date_spine_month" as spine
left join unemp_base as ub
    on spine.date_month::date = ub.date::date
    );
  
  