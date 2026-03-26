
  
    
    

    create  table
      "economics"."main"."int_inflation_measures__dbt_tmp"
  
    as (
      

-- Looping through different inflation indicators with Jina, rather than a massive join.
-- Dictionary structure is table_name: intended_alias.


with base as (
    select
        *
        , (
            (value - lag(value, 12) over (partition by indicator_name order by date)) 
            / 
            lag(value, 12) over (partition by indicator_name order by date)
        ) as inflation_rate
    from "economics"."main"."stg_fred_date_based_data"
    where
        indicator_name in ('consumer_price_index', 'core_consumer_price_index', 'personal_consumption_expenditures_index')
)

, 
    consumer_price_index_cte as (
        select
            date
            , value as consumer_price_index_value
            , inflation_rate as consumer_price_index_inflation_rate
        from base
        where
            indicator_name = 'consumer_price_index'
    )
    ,

    core_consumer_price_index_cte as (
        select
            date
            , value as core_consumer_price_index_value
            , inflation_rate as core_consumer_price_index_inflation_rate
        from base
        where
            indicator_name = 'core_consumer_price_index'
    )
    ,

    personal_consumption_expenditures_index_cte as (
        select
            date
            , value as personal_consumption_expenditures_index_value
            , inflation_rate as personal_consumption_expenditures_index_inflation_rate
        from base
        where
            indicator_name = 'personal_consumption_expenditures_index'
    )
    


select
    spine.date_month as date
    
        , consumer_price_index_value
        , consumer_price_index_inflation_rate
    
        , core_consumer_price_index_value
        , core_consumer_price_index_inflation_rate
    
        , personal_consumption_expenditures_index_value
        , personal_consumption_expenditures_index_inflation_rate
    
from "economics"."main"."int_date_spine_month" as spine

    left join consumer_price_index_cte
        on spine.date_month::date = consumer_price_index_cte.date::date

    left join core_consumer_price_index_cte
        on spine.date_month::date = core_consumer_price_index_cte.date::date

    left join personal_consumption_expenditures_index_cte
        on spine.date_month::date = personal_consumption_expenditures_index_cte.date::date

    );
  
  