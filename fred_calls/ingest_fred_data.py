import pandas as pd
import duckdb_utils as ddu
import fred_constants as fc

def insert_fred_data(
            # fred_series:list,
            series_with_table_names:dict,
            # table_names:list,
            db_path:str,
        ):
    
    fred = fc.FredClient()
    db = ddu.DuckClient(db_path)

    for series_id, table_name in series_with_table_names.items():
        # Call the Fred API and get the series you pass.
        try:
            df = fred.ingest_series(series_id)
        except ValueError as e:
            print(f"Error querying Series {series_id}. Check the series name: {e}.")
        # Upsert that series.
        db.upsert_data(df, table_name=table_name)


db_path = "/home/connor/projects/economics_project/fred_data/economics.db"

series_to_pull = {
    "UNRATE": 'unemployment_rate',
    "CPIAUCSL": "consumer_price_index",
    "CPILFESL": "core_consumer_price_index",
    "PCEPI": "personal_consumption_expenditures_index",
    "GDPC1": "real_gdp",
    "A939RX0Q048SBEA": "real_gdp_per_capita",
    "RPI": "real_income_per_capita",
    # "MAHOINUSA672N": "real_mean_household_income",
    "MEHOINUSA672N": "real_median_household_income",
}

insert_fred_data(series_to_pull, db_path)
