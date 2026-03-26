
  
  create view "economics"."main"."fct_economic_indicators__dbt_tmp" as (
    



with spine as (
    select *
    from "economics"."main"."int_date_spine_month"
),


    unemployment_rate_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'unemployment_rate'
    ) ,

    consumer_price_index_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'consumer_price_index'
    ) ,

    core_consumer_price_index_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'core_consumer_price_index'
    ) ,

    personal_consumption_expenditures_index_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'personal_consumption_expenditures_index'
    ) ,

    real_gdp_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'real_gdp'
    ) ,

    real_gdp_per_capita_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'real_gdp_per_capita'
    ) ,

    real_income_per_capita_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'real_income_per_capita'
    ) ,

    real_median_household_income_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'real_median_household_income'
    ) ,

    recession_indicators_cte as (
        select 
            date
            , value
        from "economics"."main"."stg_fred_date_based_data"
        where
            indicator_name = 'recession_indicators'
    ) 


select
    spine.date_month as date
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(unemployment_rate_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as unemployment_rate_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(consumer_price_index_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as consumer_price_index_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(core_consumer_price_index_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as core_consumer_price_index_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(personal_consumption_expenditures_index_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as personal_consumption_expenditures_index_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(real_gdp_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as real_gdp_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(real_gdp_per_capita_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as real_gdp_per_capita_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(real_income_per_capita_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as real_income_per_capita_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(real_median_household_income_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as real_median_household_income_value
    
        -- In the event that a null value is present, use previously recorded data.
        -- Example. GDP and job numbers were not available in October 2025 due to a government shutdown.
        , last_value(recession_indicators_cte.value ignore nulls) over (
                order by spine.date_month
                rows between unbounded preceding and current row
            ) as recession_indicators_value
    
from spine

left join unemployment_rate_cte 
    on spine.date_month = unemployment_rate_cte.date

left join consumer_price_index_cte 
    on spine.date_month = consumer_price_index_cte.date

left join core_consumer_price_index_cte 
    on spine.date_month = core_consumer_price_index_cte.date

left join personal_consumption_expenditures_index_cte 
    on spine.date_month = personal_consumption_expenditures_index_cte.date

left join real_gdp_cte 
    on spine.date_month = real_gdp_cte.date

left join real_gdp_per_capita_cte 
    on spine.date_month = real_gdp_per_capita_cte.date

left join real_income_per_capita_cte 
    on spine.date_month = real_income_per_capita_cte.date

left join real_median_household_income_cte 
    on spine.date_month = real_median_household_income_cte.date

left join recession_indicators_cte 
    on spine.date_month = recession_indicators_cte.date

where
    spine.date_month <= today()
order by date_month desc
  );
