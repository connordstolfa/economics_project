import duckdb
import pandas as pd
from contextlib import contextmanager

DB_PATH = "fred_data/economics.db"

@contextmanager
def get_db_connection():
    conn = duckdb.connect(DB_PATH, read_only=True)
    try:
        yield conn
    finally:
        conn.close()

def get_indicator_data(
            table_name
        ):
    with get_db_connection() as conn:
        df = conn.execute(
            f"select * from {table_name} order by date desc limit 12"
        ).df()

        # Convert everything to an object to properly fill NAs.
        df = df.astype(object).where(pd.notnull(df), None)
        return df.to_dict(orient="records")

if __name__ == '__main__':
    
    print(get_indicator_data("int_inflation_measures"))
