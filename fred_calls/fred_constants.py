import os
import requests
import pandas as pd
from dotenv import load_dotenv
from fredapi import Fred
import duckdb
import pathlib

load_dotenv()

class FredClient:
    """A basic class for interacting with the FRED API."""

    BASE_URL = "https://api.stlouisfed.org/fred"

    def __init__(self):

        # Establish a FRED API connection
        self.api_key = os.getenv('FRED_API_KEY')
        if not self.api_key:
            raise ValueError("FRED_API_KEY not found. Check your .env file.")
        
        self.fred=Fred(api_key=self.api_key)

    # Make a request to return a specific FRED datapoint (series, obsv, etc)
    # via the requests lib, rather than the FRED wraper.
    def ingest_series(
            self,
            series_id,
        )->pd.DataFrame:
        """Pass in a type of data point and an ID for the type. Rethr a Pandas DF of the data."""
        # Pull a date indexed series
        selected_series = self.fred.get_series(series_id)
        df = selected_series.to_frame().reset_index()

        df.columns = ['date', 'value']
        df['date'] = pd.to_datetime(df['date'])
        df['processed_at'] = pd.Timestamp.now()

        return df

    # def load_to_duckdb(df, table_name, db_path, table_structure):
    #     # Connect to the duck DB database that I made
    #     con = duckdb.connect(str(db_path))
        
    #     # Passing a table structure will create the duckdb tables
    #     con.execute(table_structure)

    #     # Using the fred_data schema from earlier.
    #     con.execute(
    #             f"INSERT OR REPLACE INTO raw.{table_name} SELECT * FROM df"
    #         )
    #     print(f"Successfully loaded {len(df)} rows into raw.{table_name}")
    #     con.close()

# test_structure = f"""
#                 CREATE OR REPLACE TABLE raw.unemployment_rate (
#                     date DATE PRIMARY KEY,
#                     value DOUBLE,
#                     processed_at DATETIME
#                 )
#             """
# db_path = "/home/connor/projects/economics_project/fred_data/economics.db"

if __name__ == "__main__":
    client = FredClient()

    data = client.ingest_series("UNRATE")
    # if data is not None:
        

    #     data.to_csv('fred_data_test.csv', index=False)
    #     FredClient.load_to_duckdb(data, "unemployment_rate", db_path, test_structure)