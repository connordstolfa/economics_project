

-- Jinja will loop through each raw FRED table.
-- List of indicators. Each indicator is stored in a dict with its name and table name.



with unified_data as (
    -- Now loop through the tables.
    
        select
            'unemployment_rate' as indicator_name,
            *
        from "economics"."raw"."unemployment_rate"
    
        union all
    
    
        select
            'cpi' as indicator_name,
            *
        from "economics"."raw"."consumer_price_index"
    
        union all
    
    
        select
            'core_cpi' as indicator_name,
            *
        from "economics"."raw"."core_consumer_price_index"
    
        union all
    
    
        select
            'pce' as indicator_name,
            *
        from "economics"."raw"."personal_consumption_expenditures_index"
    
        union all
    
    
        select
            'real_gdp' as indicator_name,
            *
        from "economics"."raw"."real_gdp"
    
        union all
    
    
        select
            'real_gdp_per_capita' as indicator_name,
            *
        from "economics"."raw"."real_gdp_per_capita"
    
        union all
    
    
        select
            'real_income_per_capita' as indicator_name,
            *
        from "economics"."raw"."real_income_per_capita"
    
        union all
    
    
        select
            'real_median_household_income' as indicator_name,
            *
        from "economics"."raw"."real_median_household_income"
    
    
)

select *
from unified_data