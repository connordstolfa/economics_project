import pandas as pd
import duckdb_utils as ddu
import fred_constants as fc
import json

def insert_fred_data(
            # fred_series:list,
            series_with_table_names:dict,
            # table_names:list,
            db_path:str,
        ):
    
    fred = fc.FredClient()
    db = ddu.DuckClient(db_path)

    for nested_dict in series_with_table_names:
        # for name, table_name, series_id in nested_dict.items():
            # Call the Fred API and get the series you pass.
        try:
            df = fred.ingest_series(nested_dict["series_id"])
            # Upsert that series.
            db.upsert_data(df, table_name=nested_dict["table_name"])
        except ValueError as e:
            print(f"Error querying Series {nested_dict["series_id"]}. Check the series name: {e}.")


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

def load_fred_config():
    with open('/home/connor/projects/economics_project/config/fred_series.json', 'r') as fred_series:
        return json.load(fred_series)

series_to_pull = load_fred_config()

insert_fred_data(series_to_pull, db_path)
# print(series_to_pull)
