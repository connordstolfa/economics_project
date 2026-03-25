
  
    
    

    create  table
      "economics"."main"."int_gdp_and_income__dbt_tmp"
  
    as (
      



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
    from "economics"."main"."stg_fred_date_based_data"
    where
        indicator_name in ('real_gdp', 'real_gdp_per_capita', 'real_income_per_capita', 'real_median_household_income')
)

, 
    real_gdp_cte as (
        select
            date
            , value as real_gdp_value
        from base
        where
            indicator_name = 'real_gdp'
    )
    ,

    real_gdp_per_capita_cte as (
        select
            date
            , value as real_gdp_per_capita_value
        from base
        where
            indicator_name = 'real_gdp_per_capita'
    )
    ,

    real_income_per_capita_cte as (
        select
            date
            , value as real_income_per_capita_value
        from base
        where
            indicator_name = 'real_income_per_capita'
    )
    ,

    real_median_household_income_cte as (
        select
            date
            , value as real_median_household_income_value
        from base
        where
            indicator_name = 'real_median_household_income'
    )
    


select
    spine.date_month as date
    
        , last_value(real_gdp_value ignore nulls) over (
            order by date_month 
            rows between unbounded preceding and current row
        ) as real_gdp_value
    
        , last_value(real_gdp_per_capita_value ignore nulls) over (
            order by date_month 
            rows between unbounded preceding and current row
        ) as real_gdp_per_capita_value
    
        , last_value(real_income_per_capita_value ignore nulls) over (
            order by date_month 
            rows between unbounded preceding and current row
        ) as real_income_per_capita_value
    
        , last_value(real_median_household_income_value ignore nulls) over (
            order by date_month 
            rows between unbounded preceding and current row
        ) as real_median_household_income_value
    
from "economics"."main"."int_date_spine_month" as spine

    left join real_gdp_cte
        on spine.date_month = real_gdp_cte.date

    left join real_gdp_per_capita_cte
        on spine.date_month = real_gdp_per_capita_cte.date

    left join real_income_per_capita_cte
        on spine.date_month = real_income_per_capita_cte.date

    left join real_median_household_income_cte
        on spine.date_month = real_median_household_income_cte.date

order by
    spine.date_month desc
    );
  
  