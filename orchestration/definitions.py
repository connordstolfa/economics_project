from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import run_dbt, pull_fred_data, get_times_headlines, DBT_PROJ
import os

defs = Definitions(
    assets=[pull_fred_data, get_times_headlines, run_dbt],
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(DBT_PROJ)),
    },
)
