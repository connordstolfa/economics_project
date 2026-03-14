
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date
from "economics"."main"."stg_fred_date_based_data"
where date is null



  
  
      
    ) dbt_internal_test