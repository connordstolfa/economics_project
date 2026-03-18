import os
import pandas as pd
from dotenv import load_dotenv
from fredapi import Fred

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

if __name__ == "__main__":
    client = FredClient()

    data = client.ingest_series("UNRATE")
