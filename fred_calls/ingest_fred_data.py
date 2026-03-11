import pandas as pd
import duckdb_utils as ddu
import fred_constants as fc

def insert_fred_data(
            fred_series:list,
            table_names:list,
            db_path:str,
        ):
    
    fred = fc.FredClient()
    db = ddu.DuckClient(db_path)
    print(fred, db)

    for series_id, table_name in list(zip(fred_series, table_names)):
        # Call the Fred API and get the series you pass.
        try:
            df = fred.ingest_series(series_id)
        except ValueError as e:
            print(f"Error querying Series. Check the series name: {e}.")
        
        # Upsert that series.
        db.upsert_data(df, table_name=table_name)


db_path = "/home/connor/projects/economics_project/fred_data/economics.db"

insert_fred_data(['UNRATE'], ['unemployment_rate'], db_path)