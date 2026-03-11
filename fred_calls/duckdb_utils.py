import duckdb
import pandas as pd

class DuckClient:
    """Class and methods for interacting with Duckdb"""

    def __init__(self, db_path):
        self.db_path = db_path

    def query_db(self, sql, params=None):
        """Method for querying duckdb"""
        with duckdb.connect(self.db_path) as con:
            return con.execute(sql, params).df()
        
    def upsert_data(self, df, table_name):
        df['processed_at'] = pd.Timestamp.now()

        with duckdb.connect(self.db_path) as con:
            con.execute( f"INSERT OR REPLACE INTO raw.{table_name} SELECT * FROM df")
