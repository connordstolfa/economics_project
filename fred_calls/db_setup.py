import duckdb
import os
from pathlib import Path

# Dynamically find the FRED database

current_file = Path(__file__).resolve()

# Search for anchor file
p = Path(".")
anchor_dir = "fred_economics_project.py"
files_found = list(p.rglob(anchor_dir))

if files_found:
    anchor_file_path = files_found[0]
    print(anchor_file_path)
else:
    raise ValueError(f"No file named {anchor_dir} found.")

# print(files_found)

def initialize_db(root=anchor_file_path):
    
    db_dir = root.parent / "fred_data"
    db_dir.mkdir(parents=True, exist_ok=True)
    db_path = db_dir / "economics.db"

    con = duckdb.connect(str(db_path))

    con.execute("CREATE SCHEMA IF NOT EXISTS raw;")

    print(f"Database initalized at {db_path}")

    con.close()

if __name__ == "__main__":
    initialize_db()
