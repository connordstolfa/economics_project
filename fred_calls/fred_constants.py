import os
import requests
import pandas as pd
from dotenv import load_dotenv
import pathlib

load_dotenv()

class FredClient:
    """A basic class for interacting with the FRED API."""

    BASE_URL = "https://api.stlouisfed.org/fred/"

    def __init__(self):
        self.api_key = os.getenv('FRED_API_KEY')
        if not self.api_key:
            raise ValueError("FRED_API_KEY not found. Check your .env file.")

    # Make a request to return a specific FRED datapoint (series, obsv, etc)
    # via the requests lib, rather than the FRED wraper.
    def get_data_point(
            self,
            endpoint:str,
            params=None
        )->pd.DataFrame:
        """Pass in a type of data point and an ID for the type. Rethr a Pandas DF of the data."""
        
        url = f"{self.BASE_URL}/{endpoint}"
        query_params = {
            "api_key": self.api_key,
            "file_type": "json",
        }

        if params:
            query_params.update(params)

        try:
            response = requests.get(url, params=query_params)
            response.raise_for_status() # Raise any errors that I come across.
            data = response.json()

            df = pd.DataFrame(data)

            return df
        except:
            print(requests.get(url, params=query_params))
            print("An error occurred.")

if __name__ == "__main__":
    client = FredClient()

    data = client.get_data_point("series", params={"series_id": "UNRATE"})
    if data is not None:
        print(data)