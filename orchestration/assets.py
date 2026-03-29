from dagster import asset
from dagster_dbt import dbt_assets, DbtCliResource
from pathlib import Path
import subprocess

# dagster dev -m orchestration.definitions

ROOT_DIR = Path(__file__).parent.parent.resolve()
DBT_PROJ = ROOT_DIR / "dbt_econ"
MANIFEST_PATH = DBT_PROJ / "target" / "manifest.json"

@dbt_assets(manifest=MANIFEST_PATH)
def run_dbt(context, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

@asset(
        compute_kind="python",
        description="Get economic data from the FRED API."
    )
def pull_fred_data():
    subprocess.run(["python", "app/backend/database_calls.py"], check=True)
    return "FRED data ingested"

@asset(
        compute_kind="python",
        description="Update NYT headlines"
    )
def get_times_headlines():
    subprocess.run(["python", "app/backend/scrape_the_business_page.py"], check=True)
    return "Headlines refreshed"
