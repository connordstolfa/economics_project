

-- Jinja will loop through each raw FRED table.
-- List of indicators. Each indicator is stored in a dict with its name and table name.
-- FRED indicators are stored in a variable called 'fred_indicators' in dbt_project.yml. dbt_project.yml is generated from a Python script that will update the provided indicators if a new one is added to the file fred_series.json


with unified_data as (
    
        select
            'unemployment_rate' as indicator_name,
            'UNRATE' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."unemployment_rate"
     union all 
    
        select
            'consumer_price_index' as indicator_name,
            'CPIAUCSL' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."consumer_price_index"
     union all 
    
        select
            'core_consumer_price_index' as indicator_name,
            'CPILFESL' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."core_consumer_price_index"
     union all 
    
        select
            'personal_consumption_expenditures_index' as indicator_name,
            'PCEPI' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."personal_consumption_expenditures_index"
     union all 
    
        select
            'real_gdp' as indicator_name,
            'GDPC1' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."real_gdp"
     union all 
    
        select
            'real_gdp_per_capita' as indicator_name,
            'A939RX0Q048SBEA' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."real_gdp_per_capita"
     union all 
    
        select
            'real_income_per_capita' as indicator_name,
            'RPI' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."real_income_per_capita"
     union all 
    
        select
            'real_median_household_income' as indicator_name,
            'MEHOINUSA672N' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."real_median_household_income"
     union all 
    
        select
            'recession_indicators' as indicator_name,
            'USREC' as fred_series_id, -- Extra metadata!
            date,
            value
        from "economics"."raw"."recession_indicators"
    
    
)

select *
from unified_data