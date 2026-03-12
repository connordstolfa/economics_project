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
        """This function checks if a table exists for a give data point.
        If it doesn't it createds it then runs the upsert function.
        If the table already exists, the first function won't do anythign and upsert will run."""
        df['processed_at'] = pd.Timestamp.now()

        with duckdb.connect(self.db_path) as con:
            # Check if table exits and create it if it doesn't
            con.execute(f"""
                        CREATE TABLE IF NOT EXISTS raw.{table_name} (
                            date TIMESTAMP PRIMARY KEY,
                            value DOUBLE,
                            processed_at TIMESTAMP
                        )
                    """)
            # Run the upsert function.
            con.execute( f"INSERT OR REPLACE INTO raw.{table_name} SELECT * FROM df")
